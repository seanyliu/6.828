/* See COPYRIGHT for copyright information. */

#include <inc/x86.h>
#include <inc/error.h>
#include <inc/string.h>
#include <inc/assert.h>

#include <kern/env.h>
#include <kern/pmap.h>
#include <kern/trap.h>
#include <kern/syscall.h>
#include <kern/console.h>
#include <kern/sched.h>
#include <kern/time.h>
#include <kern/e100.h>

// Print a string to the system console.
// The string is exactly 'len' characters long.
// Destroys the environment on memory errors.
static void
sys_cputs(const char *s, size_t len)
{
	// Check that the user has permission to read memory [s, s+len).
	// Destroy the environment if not.
        user_mem_assert(curenv, s, len, PTE_U);
	
	// LAB 3: Your code here.

	// Print the string supplied by the user.
	cprintf("%.*s", len, s);
}

// Read a character from the system console.
// Returns the character.
static int
sys_cgetc(void)
{
	int c;

	// The cons_getc() primitive doesn't wait for a character,
	// but the sys_cgetc() system call does.
	while ((c = cons_getc()) == 0)
		/* do nothing */;

	return c;
}

// Returns the current environment's envid.
static envid_t
sys_getenvid(void)
{
	return curenv->env_id;
}

// Destroy a given environment (possibly the currently running environment).
//
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_BAD_ENV if environment envid doesn't currently exist,
//		or the caller doesn't have permission to change envid.
static int
sys_env_destroy(envid_t envid)
{
	int r;
	struct Env *e;

	if ((r = envid2env(envid, &e, 1)) < 0)
		return r;
	env_destroy(e);
	return 0;
}

// Deschedule current environment and pick a different one to run.
static void
sys_yield(void)
{
	sched_yield();
}

// Allocate a new environment.
// Returns envid of new environment, or < 0 on error.  Errors are:
//	-E_NO_FREE_ENV if no free environment is available.
//	-E_NO_MEM on memory exhaustion.
static envid_t
sys_exofork(void)
{
	// Create the new environment with env_alloc(), from kern/env.c.
	// It should be left as env_alloc created it, except that
	// status is set to ENV_NOT_RUNNABLE, and the register set is copied
	// from the current environment -- but tweaked so sys_exofork
	// will appear to return 0.

	// LAB 4: Your code here.
	//panic("sys_exofork not implemented");

        struct Env *new_env;
        int create_status;

        // create a new environment, with parent being current env
        if ((create_status = env_alloc(&new_env, curenv->env_id)) < 0) {
          return create_status; // env_alloc can return -E_NO_FREE_ENV
        }

	// status is set to ENV_NOT_RUNNABLE
        new_env->env_status = ENV_NOT_RUNNABLE;

        // register set is copied from the current environment
        // -- but tweaked so sys_exofork will appear to return 0
        memmove(&new_env->env_tf, &curenv->env_tf, sizeof(curenv->env_tf));
        // Why do we put eax = 0?  See:
        // http://pdos.csail.mit.edu/6.828/2009/xv6-book/trap.pdf
        // Syscall records the return value of the system call function in %eax.
        new_env->env_tf.tf_regs.reg_eax = (uint32_t) 0;

        return new_env->env_id;
}

// Set envid's env_status to status, which must be ENV_RUNNABLE
// or ENV_NOT_RUNNABLE.
//
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_BAD_ENV if environment envid doesn't currently exist,
//		or the caller doesn't have permission to change envid.
//	-E_INVAL if status is not a valid status for an environment.
static int
sys_env_set_status(envid_t envid, int status)
{
	// Hint: Use the 'envid2env' function from kern/env.c to translate an
	// envid to a struct Env.
	// You should set envid2env's third argument to 1, which will
	// check whether the current environment has permission to set
	// envid's status.

	// LAB 4: Your code here.
	int r;
        struct Env *env;
	if ((r = envid2env(envid, &env, 1)) < 0) {
	  return r;
        }
        if ((status == ENV_RUNNABLE) || (status == ENV_NOT_RUNNABLE)) {
          env->env_status = status;
        } else {
          return -E_INVAL;
        }

        return 0;
	// panic("sys_env_set_status not implemented");
}

// Set envid's trap frame to 'tf'.
// tf is modified to make sure that user environments always run at code
// protection level 3 (CPL 3) with interrupts enabled.
//
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_BAD_ENV if environment envid doesn't currently exist,
//		or the caller doesn't have permission to change envid.
static int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	// LAB 4: Your code here.
	// Remember to check whether the user has supplied us with a good
	// address!
        int r;
        struct Env *env;
        if ((r = envid2env(envid, &env, 1)) < 0) {
          return r;
        }
        env->env_tf = *tf;
        env->env_tf.tf_cs |= 3;
        env->env_tf.tf_eflags |= FL_IF;
        return 0;

	//panic("sys_set_trapframe not implemented");
}

// Set the page fault upcall for 'envid' by modifying the corresponding struct
// Env's 'env_pgfault_upcall' field.  When 'envid' causes a page fault, the
// kernel will push a fault record onto the exception stack, then branch to
// 'func'.
//
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_BAD_ENV if environment envid doesn't currently exist,
//		or the caller doesn't have permission to change envid.
static int
sys_env_set_pgfault_upcall(envid_t envid, void *func)
{
	// LAB 4: Your code here.
        // seanyliu

        int r;
        struct Env *env;
	if ((r = envid2env(envid, &env, 1)) < 0) {
	  return r;
        }

        env->env_pgfault_upcall = func;

        return 0;
        
	//panic("sys_env_set_pgfault_upcall not implemented");
}

// Allocate a page of memory and map it at 'va' with permission
// 'perm' in the address space of 'envid'.
// The page's contents are set to 0.
// If a page is already mapped at 'va', that page is unmapped as a
// side effect.
//
// perm -- PTE_U | PTE_P must be set, PTE_AVAIL | PTE_W may or may not be set,
//         but no other bits may be set.  See PTE_USER in inc/mmu.h.
//
// Return 0 on success, < 0 on error.  Errors are:
//	-E_BAD_ENV if environment envid doesn't currently exist,
//		or the caller doesn't have permission to change envid.
//	-E_INVAL if va >= UTOP, or va is not page-aligned.
//	-E_INVAL if perm is inappropriate (see above).
//	-E_NO_MEM if there's no memory to allocate the new page,
//		or to allocate any necessary page tables.
static int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	// Hint: This function is a wrapper around page_alloc() and
	//   page_insert() from kern/pmap.c.
	//   Most of the new code you write should be to check the
	//   parameters for correctness.
	//   If page_insert() fails, remember to free the page you
	//   allocated!

	// LAB 4: Your code here.
        // seanyliu

        int r;
        struct Env *env;
        struct Page *env_page;

	if ((r = envid2env(envid, &env, 1)) < 0) {
	  return r;
        }

        // check that va is valid
        if ((int)va >= UTOP) { // kernel space
          return -E_INVAL;
        }
        if (va != ROUNDUP(va, PGSIZE)) { // page alignment
          return -E_INVAL;
        }

        // Check the permission bits
        if ((perm & (PTE_U | PTE_P)) != (PTE_U | PTE_P)) {
          return -E_INVAL;
        }
        if ((perm | PTE_USER) != PTE_USER) {
          return -E_INVAL;
        }

        if ((r = page_alloc(&env_page)) < 0) {
          return r; // -E_NO_MEM
        }
        if ((r = page_insert(env->env_pgdir, env_page, va, perm)) < 0) {
          // deallocate the page
          page_free(env_page);
          return r; // -E_NO_MEM
        }

        // The page's contents are set to 0.
        memset(page2kva(env_page), 0, PGSIZE);

        return 0;
	//panic("sys_page_alloc not implemented");
}


// need this for sys_ipc_try_send
static int
sys_page_map_wopermcheck(envid_t srcenvid, void *srcva,
	     envid_t dstenvid, void *dstva, int perm)
{
	// Hint: This function is a wrapper around page_lookup() and
	//   page_insert() from kern/pmap.c.
	//   Again, most of the new code you write should be to check the
	//   parameters for correctness.
	//   Use the third argument to page_lookup() to
	//   check the current permissions on the page.

	// LAB 4: Your code here.
        // seanyliu
        int r;
        pte_t *src_pte;
        pte_t *dst_pte;
        struct Env *src_env;
        struct Env *dst_env;
        struct Page *src_page;

        // -E_BAD_ENV if srcenvid and/or dstenvid doesn't currently exist,
        // or the caller doesn't have permission to change one of them.
	if ((r = envid2env(srcenvid, &src_env, 0)) < 0) {
	  return r;
        }
	if ((r = envid2env(dstenvid, &dst_env, 0)) < 0) {
	  return r;
        }

        // check that srcva is valid
        if ((int)srcva >= UTOP) { // kernel space
          return -E_INVAL;
        }
        if (srcva != ROUNDUP(srcva, PGSIZE)) { // page alignment
          return -E_INVAL;
        }

        // check that dstva is valid
        if ((int)dstva >= UTOP) { // kernel space
          return -E_INVAL;
        }
        if (dstva != ROUNDUP(dstva, PGSIZE)) { // page alignment
          return -E_INVAL;
        }

        // -E_INVAL if srcva is not mapped in srcenvid's address space.
        src_page = page_lookup(src_env->env_pgdir, srcva, &src_pte);
        if (src_page == NULL) {
          return -E_INVAL;
        }

        // Check the permission bits
        if ((perm & (PTE_U | PTE_P)) != (PTE_U | PTE_P)) {
          return -E_INVAL;
        }
        if ((perm | PTE_USER) != PTE_USER) {
          return -E_INVAL;
        }

        // -E_INVAL if (perm & PTE_W), but srcva is read-only in srcenvid's
        // address space.
        if ((perm & PTE_W) && (!(*src_pte & PTE_W))) {
          return -E_INVAL;
        }

        // Map the page of memory at 'srcva' in srcenvid's address space
        // at 'dstva' in dstenvid's address space with permission 'perm'.
        // Perm has the same restrictions as in sys_page_alloc, except
        // that it also must not grant write access to a read-only
        // page.
        if ((r = page_insert(dst_env->env_pgdir, src_page, dstva, perm)) < 0) {
          return r; // -E_NO_MEM
        }

        return 0;
	// panic("sys_page_map not implemented");
}



// Unmap the page of memory at 'va' in the address space of 'envid'.
// If no page is mapped, the function silently succeeds.
//
// Map the page of memory at 'srcva' in srcenvid's address space
// at 'dstva' in dstenvid's address space with permission 'perm'.
// Perm has the same restrictions as in sys_page_alloc, except
// that it also must not grant write access to a read-only
// page.
//
// Return 0 on success, < 0 on error.  Errors are:
//	-E_BAD_ENV if srcenvid and/or dstenvid doesn't currently exist,
//		or the caller doesn't have permission to change one of them.
//	-E_INVAL if srcva >= UTOP or srcva is not page-aligned,
//		or dstva >= UTOP or dstva is not page-aligned.
//	-E_INVAL is srcva is not mapped in srcenvid's address space.
//	-E_INVAL if perm is inappropriate (see sys_page_alloc).
//	-E_INVAL if (perm & PTE_W), but srcva is read-only in srcenvid's
//		address space.
//	-E_NO_MEM if there's no memory to allocate any necessary page tables.
static int
sys_page_map(envid_t srcenvid, void *srcva,
	     envid_t dstenvid, void *dstva, int perm)
{
	// Hint: This function is a wrapper around page_lookup() and
	//   page_insert() from kern/pmap.c.
	//   Again, most of the new code you write should be to check the
	//   parameters for correctness.
	//   Use the third argument to page_lookup() to
	//   check the current permissions on the page.

	// LAB 4: Your code here.
        // seanyliu
        int r;
        pte_t *src_pte;
        pte_t *dst_pte;
        struct Env *src_env;
        struct Env *dst_env;
        struct Page *src_page;

        // -E_BAD_ENV if srcenvid and/or dstenvid doesn't currently exist,
        // or the caller doesn't have permission to change one of them.
	if ((r = envid2env(srcenvid, &src_env, 1)) < 0) {
	  return r;
        }
	if ((r = envid2env(dstenvid, &dst_env, 1)) < 0) {
	  return r;
        }

        // check that srcva is valid
        if ((int)srcva >= UTOP) { // kernel space
          return -E_INVAL;
        }
        if (srcva != ROUNDUP(srcva, PGSIZE)) { // page alignment
          return -E_INVAL;
        }

        // check that dstva is valid
        if ((int)dstva >= UTOP) { // kernel space
          return -E_INVAL;
        }
        if (dstva != ROUNDUP(dstva, PGSIZE)) { // page alignment
          return -E_INVAL;
        }

        // -E_INVAL if srcva is not mapped in srcenvid's address space.
        src_page = page_lookup(src_env->env_pgdir, srcva, &src_pte);
        if (src_page == NULL) {
          return -E_INVAL;
        }

        // Check the permission bits
        if ((perm & (PTE_U | PTE_P)) != (PTE_U | PTE_P)) {
          return -E_INVAL;
        }
        if ((perm | PTE_USER) != PTE_USER) {
          return -E_INVAL;
        }

        // -E_INVAL if (perm & PTE_W), but srcva is read-only in srcenvid's
        // address space.
        if ((perm & PTE_W) && (!(*src_pte & PTE_W))) {
          return -E_INVAL;
        }

        // Map the page of memory at 'srcva' in srcenvid's address space
        // at 'dstva' in dstenvid's address space with permission 'perm'.
        // Perm has the same restrictions as in sys_page_alloc, except
        // that it also must not grant write access to a read-only
        // page.
        if ((r = page_insert(dst_env->env_pgdir, src_page, dstva, perm)) < 0) {
          return r; // -E_NO_MEM
        }

        return 0;
	// panic("sys_page_map not implemented");
}

// Unmap the page of memory at 'va' in the address space of 'envid'.
// If no page is mapped, the function silently succeeds.
//
// Return 0 on success, < 0 on error.  Errors are:
//	-E_BAD_ENV if environment envid doesn't currently exist,
//		or the caller doesn't have permission to change envid.
//	-E_INVAL if va >= UTOP, or va is not page-aligned.
static int
sys_page_unmap(envid_t envid, void *va)
{
	// Hint: This function is a wrapper around page_remove().

	// LAB 4: Your code here.
        // seanyliu

        int r;
        struct Env *env;
	if ((r = envid2env(envid, &env, 1)) < 0) {
	  return r;
        }

        // check that srcva is valid
        if ((int)va >= UTOP) { // kernel space
          return -E_INVAL;
        }
        if (va != ROUNDUP(va, PGSIZE)) { // page alignment
          return -E_INVAL;
        }

        page_remove(env->env_pgdir, va);

        return 0;

	//panic("sys_page_unmap not implemented");
}

// Try to send 'value' to the target env 'envid'.
// If srcva < UTOP, then also send page currently mapped at 'srcva',
// so that receiver gets a duplicate mapping of the same page.
//
// The send fails with a return value of -E_IPC_NOT_RECV if the
// target has not requested IPC with sys_ipc_recv.
//
// Otherwise, the send succeeds, and the target's ipc fields are
// updated as follows:
//    env_ipc_recving is set to 0 to block future sends;
//    env_ipc_from is set to the sending envid;
//    env_ipc_value is set to the 'value' parameter;
//    env_ipc_perm is set to 'perm' if a page was transferred, 0 otherwise.
// The target environment is marked runnable again, returning 0
// from the paused ipc_recv system call.
//
// If the sender sends a page but the receiver isn't asking for one,
// then no page mapping is transferred, but no error occurs.
// The ipc only happens when no errors occur.
//
// Returns 0 on success where no page mapping occurs,
// 1 on success where a page mapping occurs, and < 0 on error.
// Errors are:
//	-E_BAD_ENV if environment envid doesn't currently exist.
//		(No need to check permissions.)
//	-E_IPC_NOT_RECV if envid is not currently blocked in sys_ipc_recv,
//		or another environment managed to send first.
//	-E_INVAL if srcva < UTOP but srcva is not page-aligned.
//	-E_INVAL if srcva < UTOP and perm is inappropriate
//		(see sys_page_alloc).
//	-E_INVAL if srcva < UTOP but srcva is not mapped in the caller's
//		address space.
//	-E_INVAL if (perm & PTE_W), but srcva is read-only in the
//		current environment's address space.
//	-E_NO_MEM if there's not enough memory to map srcva in envid's
//		address space.
static int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, unsigned perm)
{
  // LAB 4: Your code here.
  //panic("sys_ipc_try_send not implemented");
  // seanyliu
  int r;
  struct Env *target_env;
  struct Page *src_page;
  struct Page *dst_page;
  pte_t *src_pte;

  // -E_BAD_ENV if environment envid doesn't currently exist.
  if ((r = envid2env(envid, &target_env, 0)) < 0) return r;

  // -E_IPC_NOT_RECV if envid is not currently blocked in sys_ipc_recv,
  // or another environment managed to send first.
  if (target_env->env_ipc_recving != 1) {
    return -E_IPC_NOT_RECV;
  }

  if (((int)srcva < UTOP) && (target_env->env_ipc_dstva != 0)) {
    // -E_INVAL if srcva < UTOP but srcva is not page-aligned.
    // -E_INVAL if srcva < UTOP and perm is inappropriate
    //   (see sys_page_alloc).
    // -E_INVAL if srcva < UTOP but srcva is not mapped in the caller's
    //   address space.
    // -E_INVAL if (perm & PTE_W), but srcva is read-only in the
    //   current environment's address space.
    // -E_NO_MEM if there's not enough memory to map srcva in envid's
    //   address space.
    r = sys_page_map_wopermcheck(sys_getenvid(), srcva, envid, target_env->env_ipc_dstva, perm);
    if (r < 0) return r;
  }

  // Otherwise, the send succeeds, and the target's ipc fields are
  // updated as follows:
  //    env_ipc_recving is set to 0 to block future sends;
  //    env_ipc_from is set to the sending envid;
  //    env_ipc_value is set to the 'value' parameter;
  //    env_ipc_perm is set to 'perm' if a page was transferred, 0 otherwise.
  // The target environment is marked runnable again, returning 0
  // from the paused ipc_recv system call.
  target_env->env_ipc_recving = 0;
  target_env->env_ipc_from = sys_getenvid();
  target_env->env_ipc_value = value;
  target_env->env_status = ENV_RUNNABLE;
  if (((int)srcva < UTOP) && (target_env->env_ipc_dstva != 0)) {
    target_env->env_ipc_perm = perm;
    return 1;
  } else {
    target_env->env_ipc_perm = 0;
    return 0;
  }

}

// Block until a value is ready.  Record that you want to receive
// using the env_ipc_recving and env_ipc_dstva fields of struct Env,
// mark yourself not runnable, and then give up the CPU.
//
// If 'dstva' is < UTOP, then you are willing to receive a page of data.
// 'dstva' is the virtual address at which the sent page should be mapped.
//
// This function only returns on error, but the system call will eventually
// return 0 on success.
// Return < 0 on error.  Errors are:
//	-E_INVAL if dstva < UTOP but dstva is not page-aligned.
static int
sys_ipc_recv(void *dstva)
{
  // LAB 4: Your code here.
  // seanyliu

  // Verify that the dstva is correct
  if (((int)dstva < UTOP) && (dstva != ROUNDUP(dstva, PGSIZE))) {
    return -E_INVAL;
  }

  if ((int)dstva < UTOP) {
    curenv->env_ipc_dstva = dstva;
  } else {
    curenv->env_ipc_dstva = 0;
  }
  curenv->env_ipc_recving = 1;
  curenv->env_status = ENV_NOT_RUNNABLE;
  curenv->env_tf.tf_regs.reg_eax = 0;
  sys_yield();

  // panic("sys_ipc_recv not implemented");
  return 0;
}


// Set envid's env_priority to priority, which must be in the correct bounds
//
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_BAD_ENV if environment envid doesn't currently exist,
//		or the caller doesn't have permission to change envid.
//	-E_INVAL if priority is not a valid priority for an environment.
static int
sys_env_set_priority(envid_t envid, int priority)
{
	// Hint: Use the 'envid2env' function from kern/env.c to translate an
	// envid to a struct Env.
	// You should set envid2env's third argument to 1, which will
	// check whether the current environment has permission to set
	// envid's priority.

	// Lab 4: Challenge
        // seanyliu
	int r;
        struct Env *env;
	if ((r = envid2env(envid, &env, 1)) < 0) {
	  return r;
        }
        if ((ENV_PR_LOWEST <= priority) && (priority <= ENV_PR_HIGHEST)) {
          env->env_priority = priority;
        } else {
          return -E_INVAL;
        }

        return 0;
}

// LAB 6
/*
static int
sys_transmit_packet(char* packet, int pktsize) {
  int r;
  if (pktsize > MAX_PKT_SIZE) {
    return -E_INVAL;
  }
  if ((r = e100_transmit_packet(packet, pktsize)) < 0) {
    return r;
  }
  return 0;
}
*/

static int
sys_transmit_packet(char *packet, int size)
{
  return e100_transmit_packet(packet,size);
}

static int
sys_receive_packet(char *packet, int *size)
{
  int r;
  if ((r = e100_receive_packet(packet, size)) < 0) {
    return r;
  }
  return 0;
}

// Challenge: Lab 6
static int
sys_receive_packet_zerocopy(int *size)
{
  int r;
  if ((r = e100_receive_packet_zerocopy(size)) < 0) {
    return r;
  }
  return 0;
}

// Return the current time.
static int
sys_time_msec(void) 
{
	// LAB 6: Your code here.
        return time_msec();
	//panic("sys_time_msec not implemented");
}

// Challenge: LAB 6
static int
sys_map_receive_buffers(char *first_buffer)
{
        int r;
        if ((r = e100_map_receive_buffers(first_buffer)) < 0) {
          return r;
        }
        return 0;
}


// Dispatches to the correct kernel function, passing the arguments.
int32_t
syscall(uint32_t syscallno, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
	// Call the function corresponding to the 'syscallno' parameter.
	// Return any appropriate return value.
	// LAB 3: Your code here.

        // seanyliu
        if (syscallno >= 0 && syscallno < NSYSCALLS) {
          //cprintf("%d\n", syscallno);
          switch (syscallno) {
            case SYS_cputs:
              // sys_cputs(const char *s, size_t len)
              sys_cputs((char *)a1, a2);
              break;
            case SYS_cgetc:
              return sys_cgetc();
              break;
            case SYS_getenvid:
              return sys_getenvid();
              break;
            case SYS_env_destroy:
              return sys_env_destroy(a1);
              break;
            case SYS_yield:
              sys_yield();
              break;
            case SYS_exofork:
              return sys_exofork();
              break;
            case SYS_env_set_status:
              return sys_env_set_status((envid_t) a1, (int) a2);
              break;
            case SYS_page_alloc:
              return sys_page_alloc((envid_t) a1, (void *) a2, (int) a3);
              break;
            case SYS_page_map:
              return sys_page_map((envid_t) a1, (void *) a2, (envid_t) a3, (void *) a4, (int) a5);
              break;
            case SYS_page_unmap:
              return sys_page_unmap((envid_t) a1, (void *) a2);
              break;
            case SYS_env_set_pgfault_upcall:
              return sys_env_set_pgfault_upcall((envid_t) a1, (void *) a2);
              break;
            case SYS_ipc_try_send:
              return sys_ipc_try_send((envid_t) a1, (uint32_t) a2, (void *) a3, (unsigned) a4);
              break;
            case SYS_ipc_recv:
              return sys_ipc_recv((void *) a1);
              break;
            case SYS_env_set_trapframe:
              return sys_env_set_trapframe((envid_t) a1, (struct Trapframe*)a2);
              break;
            // Lab 4: Challenge
            case SYS_env_set_priority:
              return sys_env_set_priority((envid_t) a1, (int) a2);
              break;
            case SYS_time_msec:
              return sys_time_msec();
              break;
            case SYS_transmit_packet:
              return sys_transmit_packet((char *)a1, (int) a2);
              break;
            case SYS_receive_packet:
              return sys_receive_packet((char *)a1, (int*) a2);
              break;
            case SYS_receive_packet_zerocopy:
              return sys_receive_packet_zerocopy((int *)a1);
              break;
            case SYS_map_receive_buffers:
              return sys_map_receive_buffers((char *)a1);
              break;
            default:
	      panic("kern/syscall.c: unexpected syscall %d\n", syscallno);
              break;
          }
        } else {
          return -E_INVAL;
        }

        return 0;

	//panic("syscall not implemented");
}

