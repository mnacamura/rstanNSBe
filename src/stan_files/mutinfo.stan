data {
    /* Number of samples */
    int<lower=0> N;

    /* Observation vectors Y = (v1, v2) */
    int<lower=0, upper=2> Y[N, 2];
    // Elements are given by 0: NA, 1: true, or 2: false.
}

parameters {
    /* Probabilities to obvserve 1 or 2 in each sample of v1 and v2.
       p(1, 1) = theta[1], p(1, 2) = theta[2], p(2, 1) = theta[3], and
       p(2, 2) = theta[4]. */
    simplex[4] theta;
}

transformed parameters {
    matrix<lower=0, upper=1>[2, 2] p;  // Joint distribution
    matrix<lower=0, upper=1>[2, 2] p1; // Marginal distribution of v1
    matrix<lower=0, upper=1>[2, 2] p2; // Marginal distribution of v2

    /* Note: p1 and p2 have to be matrices for calculating 'I' below. */
    p[1, 1] = theta[1];
    p[1, 2] = theta[2];
    p[2, 1] = theta[3];
    p[2, 2] = theta[4];
    p1[1, 1] = p[1, 1] + p[1, 2]; p1[1, 2] = p1[1, 1];
    p1[2, 1] = p[2, 1] + p[2, 2]; p1[2, 2] = p1[2, 1];
    p2[1, 1] = p[1, 1] + p[2, 1]; p2[2, 1] = p2[1, 1];
    p2[1, 2] = p[1, 2] + p[2, 2]; p2[2, 2] = p2[1, 2];
}

model {
    for (i in 1:N)
        if (Y[i, 1] > 0 && Y[i, 2] > 0)  // both observed
            target += log(p[Y[i, 1], Y[i, 2]]);
        else if (Y[i, 1] > 0)  // only v1 is observed
            target += log(p1[Y[i, 1], 1]);
        else if (Y[i, 2] > 0)  // only v2 is observed
            target += log(p2[1, Y[i, 2]]);
}

generated quantities {
    /* Mutual information */
    real<lower=0> I;
    I = sum(p .* (log2(p) - log2(p1) - log2(p2)));
}
