# ### m12.2t.jl

using Pkg, DrWatson

@quickactivate "StatisticalRethinkingTuring"
using Turing
using StatisticalRethinking
Turing.setprogress!(false)

df = CSV.read(sr_datadir("reedfrogs.csv"), DataFrame);

# Set number of tanks

df.tank = 1:size(df, 1);

  
# Thanks to Kai Xu!

@model ppl12_2(density, tank, surv) = begin

    # Separate priors on α and σ for each tank
    σ ~ truncated(Cauchy(0, 1), 0, Inf)
    α ~ Normal(0, 1)

    # Number of unique tanks in the data set
    N_tank = length(tank)
    a_tank ~ filldist(Normal(α, σ), N_tank)

    # Observation
    logitp = a_tank[tank]
    surv .~ BinomialLogit.(density, logitp)

end

# Sample 

m12_2t = ppl12_2(Vector{Int64}(df.density), Vector{Int64}(df.tank),
    Vector{Int64}(df.surv))
nchains = 4; sampler = NUTS(0.65); nsamples=2000
chns12_2t = mapreduce(c -> sample(m12_2t, sampler, nsamples), chainscat, 1:nchains)
    
# CmdStan result

m12_2s_results = "
                mean   sd  5.5% 94.5% n_eff Rhat
a               1.30 0.25  0.90  1.70 11662    1
sigma       1.62 0.22  1.30  1.99  6556    1
a_tank[1]   2.12 0.88  0.84  3.60 16091    1
a_tank[2]   3.05 1.10  1.52  4.92 10962    1
a_tank[3]   1.00 0.66 -0.02  2.10 18175    1
a_tank[4]   3.05 1.11  1.47  4.96 10181    1
a_tank[5]   2.13 0.87  0.85  3.62 13720    1
a_tank[6]   2.12 0.86  0.86  3.59 11628    1
a_tank[7]   3.07 1.13  1.47  5.03 10315    1
a_tank[8]   2.13 0.87  0.86  3.60 13754    1
a_tank[9]  -0.18 0.60 -1.14  0.76 18218    1
a_tank[10]  2.11 0.86  0.83  3.58 15121    1
a_tank[11]  1.00 0.67 -0.04  2.09 17390    1
a_tank[12]  0.58 0.62 -0.41  1.60 17209    1
a_tank[13]  0.99 0.66 -0.04  2.09 15225    1
a_tank[14]  0.19 0.62 -0.79  1.20 18293    1
a_tank[15]  2.13 0.89  0.83  3.63 12445    1
a_tank[16]  2.11 0.87  0.87  3.61 12385    1
a_tank[17]  2.89 0.80  1.76  4.29 12583    1
a_tank[18]  2.38 0.66  1.43  3.49 14437    1
a_tank[19]  2.00 0.58  1.12  2.99 13959    1
a_tank[20]  3.67 1.03  2.20  5.44 10629    1
a_tank[21]  2.38 0.65  1.42  3.47 15309    1
a_tank[22]  2.39 0.66  1.42  3.49 13614    1
a_tank[23]  2.40 0.67  1.41  3.53 11868    1
a_tank[24]  1.69 0.52  0.90  2.55 18468    1
a_tank[25] -1.00 0.45 -1.74 -0.30 18153    1
a_tank[26]  0.16 0.40 -0.47  0.81 21895    1
a_tank[27] -1.44 0.50 -2.28 -0.69 16718    1
a_tank[28] -0.47 0.41 -1.15  0.17 20160    1
a_tank[29]  0.15 0.40 -0.48  0.80 19401    1
a_tank[30]  1.44 0.49  0.70  2.24 15407    1
a_tank[31] -0.64 0.42 -1.33 -0.01 15356    1
a_tank[32] -0.31 0.40 -0.95  0.32 19130    1
a_tank[33]  3.18 0.78  2.06  4.55 10894    1
a_tank[34]  2.70 0.66  1.75  3.84 13573    1
a_tank[35]  2.69 0.64  1.74  3.78 13876    1
a_tank[36]  2.06 0.53  1.26  2.92 16329    1
a_tank[37]  2.06 0.51  1.29  2.91 14672    1
a_tank[38]  3.88 0.97  2.52  5.57  9349    1
a_tank[39]  2.70 0.64  1.77  3.78 13444    1
a_tank[40]  2.34 0.56  1.49  3.31 14966    1
a_tank[41] -1.82 0.48 -2.61 -1.10 14214    1
a_tank[42] -0.58 0.36 -1.16 -0.02 17203    1
a_tank[43] -0.46 0.35 -1.02  0.08 17762    1
a_tank[44] -0.34 0.34 -0.90  0.20 16740    1
a_tank[45]  0.58 0.35  0.02  1.14 18946    1
a_tank[46] -0.57 0.34 -1.13 -0.03 19761    1
a_tank[47]  2.05 0.51  1.30  2.90 15122    1
a_tank[48]  0.00 0.33 -0.53  0.53 18236    1
";

# End of `12/m12.2t.jl`
