#include <inc/assert.h>

#include <kern/env.h>
#include <kern/pmap.h>
#include <kern/monitor.h>


// Choose a user environment to run and run it.
void
sched_yield(void)
{
	// Implement simple round-robin scheduling.
	// Search through 'envs' for a runnable environment,
	// in circular fashion starting after the previously running env,
	// and switch to the first such environment found.
	// It's OK to choose the previously running env if no other env
	// is runnable.
	// But never choose envs[0], the idle environment,
	// unless NOTHING else is runnable.

	// LAB 4: Your code here.
        // seanyliu

        // calculate the previous environment index
        int previdx = 0;
        if (curenv != NULL) {
          previdx = ENVX(curenv->env_id);
        }

        // LAB 4: Challenge
        // implement fixed priority scheduler
        int bidx; // base idx
        int eidx; // env idx
        int newidx = 0; // next priority to select
        int newpriority = ENV_PR_LOWEST - 1; // next priority's index
        for (bidx = 0; bidx < NENV; bidx++) {
          // for loop also checks the previous idx
          eidx = (bidx + previdx + 1) % NENV; // explicitly start at previdx+1
          if (eidx != 0) { // skip 0
            if (envs[eidx].env_status == ENV_RUNNABLE) {
              if (envs[eidx].env_priority > newpriority) {
                newpriority = envs[eidx].env_priority;
                newidx = eidx;
              }
            }
          }
        }
        if (newidx != 0) {
          env_run(&envs[newidx]);
          return;
        }

        /*
        // select the next environment
        int newidx = previdx + 1;
        while (newidx != previdx) {
          if (newidx >= NENV) {
            newidx = 0;
            continue; // because you skip over 0
          }
          if (newidx != 0) { // skip 0
            if (envs[newidx].env_status == ENV_RUNNABLE) {
              env_run(&envs[newidx]);
              return;
            }
          }
          newidx++;
        }

        // didn't find another enviornment.  check the previous env.
        if (envs[previdx].env_status == ENV_RUNNABLE) {
          env_run(&envs[previdx]);
          return;
        }
        */

	// Run the special idle environment when nothing else is runnable.
	if (envs[0].env_status == ENV_RUNNABLE)
		env_run(&envs[0]);
	else {
		cprintf("Destroyed all environments - nothing more to do!\n");
		while (1)
			monitor(NULL);
	}
}
