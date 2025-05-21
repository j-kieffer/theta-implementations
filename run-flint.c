/*
  Run experiments for a fixed genus and precision using FLINT
  Compile with: gcc -I/path/to/include run-fline.c -L/path/to/lib -lflint -o run-flint.exe
*/

#include <stdlib.h>
#include <math.h>
#include "profiler.h"
#include "acb.h"
#include "acb_mat.h"
#include "acb_theta.h"

static int usage(char * argv[])
{
    flint_printf("usage: %s g filename prec use_sum\n", argv[0]);
    return 1;
}

int main(int argc, char * argv[])
{
    /* Declare variables */
    slong g, prec, n, reps;
    acb_mat_t tau;
    acb_ptr z;
    acb_t th;
    int use_sum;
    FILE * f_input;
    char * line = NULL;
    size_t size = 0;
    timeit_t t0;
    double t;
    slong i, j;

    if (argc < 5)
    {
        return usage(argv);
    }

    g = atol(argv[1]);
    n = 1 << g;
    prec = atol(argv[3]);
    use_sum = atoi(argv[4]);

    acb_mat_init(tau, g, g);
    z = _acb_vec_init(g);
    acb_init(th);
    f_input = fopen(argv[2], "r");

    if (f_input == NULL)
    {
        flint_printf("Could not open file %s\n", f_input);
        return usage(argv);
    }

    for (i = 0; i < g; i++)
    {
        for (j = 0; j < g; j++)
        {
            getline(&line, &size, f_input);
            arb_set_str(acb_realref(acb_mat_entry(tau, i, j)), line, prec);
            getline(&line, &size, f_input);
            arb_set_str(acb_imagref(acb_mat_entry(tau, i, j)), line, prec);
        }
    }

    TIMEIT_REPEAT(t0, reps);
    if (use_sum)
    {
        acb_theta_ctx_tau_t ctx_tau;
        acb_theta_ctx_z_t ctx_z;
        arb_ptr distances;

        acb_theta_ctx_tau_init(ctx_tau, 0, g);
        acb_theta_ctx_z_init(ctx_z, g);
        distances = _arb_vec_init(n);

        acb_theta_ctx_tau_set(ctx_tau, tau, prec);
        acb_theta_ctx_z_set(ctx_z, z, ctx_tau, prec);

        acb_theta_sum(th, ctx_z, 1, ctx_tau, distances, 0, 0, 0, prec);

        acb_theta_ctx_tau_clear(ctx_tau);
        acb_theta_ctx_z_clear(ctx_z);
        _arb_vec_clear(distances, n);
    }
    else
    {
        acb_theta_jet_notransform(th, z, 1, tau, 0, 0, 0, 0, prec);
    }
    TIMEIT_END_REPEAT(t0, reps);
    t = 0.001 * ((double) t0->cpu) / reps;
    flint_printf("%f", t);

    acb_mat_clear(tau);
    _acb_vec_clear(z, g);
    acb_clear(th);
    fclose(f_input);
    free(line);

    flint_cleanup();
    return 0;
}
