
//*** RITMO SINUSAL (segmentado P,QRS,T)
//***************************************
//Duracion de p2 (medido con oscilosc): 62ms
static const short  p2_data[] = { 
963, 973, 983, 994, 1005, 
1024, 1043, 1062, 1087, 1112, 
1126, 1136, 1146, 1156, 1172, 
1187, 1202, 1216, 1229, 1241, 
1254, 1264, 1271, 1279, 1287, 
1284, 1279, 1274, 1268, 1263, 
1258, 1253, 1246, 1237, 1227, 
1218, 1211, 1203, 1195, 1184, 
1171, 1159, 1146, 1136, 1125, 
1115, 1103, 1088, 1073, 1057, 
1040, 1021, 1004, 987, 978, 
970, 963};
//Duracion de qrs2 (medido con oscilosc): 76ms
static const short  qrs2_data[] = {
963, 965, 960, 954, 947, 941, 932, 920, 913, 907, 894, 865, 733, 
555, 507, 632, 752, 807, 896, 1023, 1127, 1347, 2085, 2474, 2595, 
2695, 3135, 3217, 3403, 3581, 3847, 3798, 3453, 3053, 2810, 
2258, 1734, 998, 355, 203, 33, 90, 160, 275, 309, 
343, 399, 484, 602, 703, 802, 856, 895, 938, 1016, 
1041, 1054, 1066, 1064, 1058, 1053, 1048, 1043, 1038, 1033, 
1028, 1022, 1017, 1011, 1006, 1001, 998, 994, 991, 988, 
985, 981, 976, 971, 966, 963};
//Duracion de t2 (medido con oscilosc): 100ms
static const short  t2_data[] = {
963, 965, 967, 969, 971, 974, 976, 980, 985, 989, 993, 
997, 1002, 1011, 1019, 1028, 1036, 1045, 1055, 1064, 1076, 
1088, 1101, 1114, 1126, 1141, 1158, 1173, 1183, 1193, 1203,
1214, 1227, 1240, 1250, 1259, 1269, 1286, 1303, 1315, 1328, 1334, 
1341, 1345, 1349, 1353, 1357, 1359, 1359, 1359, 1358, 1354, 1350,
1347, 1345, 1341, 1336, 1332, 1327, 1324, 1322, 1317, 1312, 1301,
1288, 1281, 1275, 1265, 1256, 1246, 1233, 1227, 1221, 1208, 1194,
1178, 1162, 1154, 1148, 1140, 1131, 1123, 1114, 1107, 1099, 1082,
1069, 1058, 1048, 1043, 1038, 1029, 1021, 1013, 1005, 1001, 
997, 990, 980, 970, 963};




//*** FA (no hay onda P)
//*********************************
// Construida a partir del rimo sinusal, añadiendo un 'idle' aleatorio
//FA1: FA rapida, 250lpm (media aprox)
//FA2: FA media,  190lpm (media aprox)


//*** TV
//***********************************************
//TV1: T=280ms, 214.2 lpm  
static const short  tv1_data[] = {
4512, 4512, 4512, 4512, 4512, 4512, 4512, 4512, 4512, 4512,  
4512, 4512, 4512, 4512, 4512, 4512, 4512, 4512, 4512, 4512,
4512, 4512, 4512, 4512, 4512, 4512, 4512, 4512, 4512, 4512,
4512, 4552, 4592, 4632, 4672, 4722, 4772, 4822, 4872, 4922,
4922, 4922, 4922, 4922, 4922, 4922, 4922, 4922, 4922, 4922,
4922, 4922, 4922, 4922, 4922, 4922, 4922, 4922, 4922, 4922,
4972, 5022, 5071, 5121, 5171, 5221, 5271, 5338, 5405, 5471, 
5538, 5604, 5671, 5738, 5804, 5871, 5871, 5871, 5871, 5871,
5871, 5871, 5871, 5871, 5871, 5871, 5871, 5871, 5871, 5871, 
5938, 5998, 6051, 6104, 6104, 6104, 6104, 6104, 6104, 6104, 
6158, 6211, 6264, 6317, 6371, 6459, 6548, 6637, 6726, 6815, 
6903, 6992, 7081, 7170, 7238, 7304, 7371, 7438, 7492, 7532, 
7572, 7612, 7652, 7692, 7731, 7771, 7805, 7838, 7871, 7904, 
7937, 7971, 7972, 7972, 7972, 7972, 7972, 7972, 7972, 7972,
7972, 7972, 7972, 7972, 7972, 7972, 7972, 7972, 7972, 7972,
7972, 7972, 7972, 7972, 7972, 7972, 7972, 7972, 7972, 7972,
7971, 7971, 7971, 7971, 7971, 7970, 7970, 7969, 7969, 7968, 
7968, 7945, 7922, 7899, 7876, 7853, 7830, 7807, 7784, 7761, 
7738, 7715, 7692, 7669, 7630, 7579, 7528, 7476, 7425, 7374, 
7272, 7144, 7093, 7093, 7093, 7093, 7093, 7093, 7093, 7093,
7093, 7093, 7093, 7093, 7093, 7093, 7093, 7093, 7093, 7093,
7093, 7093, 7093, 7093, 7093, 7093, 7093, 7093, 7093, 7093,
7042, 7042, 7042, 7042, 7042, 7042, 7042 ,7042, 7042, 7042,
6991, 6939, 6888, 6834, 6766, 6698, 6698, 6698, 6698, 6698, 
6629, 6561, 6477, 6386, 6295, 6204, 6122, 6070, 6019, 5968, 
5917, 5865, 5803, 5712, 5621, 5530, 5439, 5380, 5329, 5278, 
5226, 5175, 5124, 5072, 5021, 4970, 4918, 4867, 4816, 4770, 
4724, 4678, 4633, 4577, 4512, 4512, 4512, 4512, 4512, 4512,
};

//TV2: T=328ms, 183 lpm
static const short  tv2_data[] = {
2695, 2702, 2708, 2717, 2730, 2743, 2756, 2769, 2782, 2795, 
2808, 2821, 2834, 2847, 2860, 2873, 2886, 2899, 2912, 2925, 
2929, 2932, 2935, 2938, 2942, 2945, 2948, 2951, 2955, 2958, 
2961, 2964, 2968, 2971, 2974, 2977, 2985, 2995, 3005, 3015, 
3024, 3034, 3044, 3054, 3063, 3073, 3083, 3093, 3102, 3112, 
3122, 3132, 3152, 3191, 3231, 3270, 3309, 3348, 3387, 3426, 
3465, 3504, 3543, 3582, 3622, 3661, 3700, 3739, 3777, 3787, 
3796, 3806, 3816, 3826, 3835, 3845, 3855, 3865, 3874, 3884, 
3894, 3904, 3914, 3923, 3933, 3941, 3947, 3954, 3960, 3967, 
3973, 3980, 3986, 3993, 3999, 4006, 4012, 4019, 4025, 4032, 
4038, 4044, 4047, 4050, 4053, 4057, 4060, 4063, 4066, 4070, 
4073, 4076, 4079, 4083, 4086, 4089, 4092, 
4095, 4092, 4090, 4088, 4086, 4084, 4082, 4079, 4077, 4075, 
4073, 4071, 4069, 4066, 4064, 4062, 4060, 4058, 4056, 4053, 
4051, 4049, 4047, 4045, 4042, 4040, 4038, 4036, 4034, 4032, 
4029, 4027, 4025, 4023, 4021, 4019, 4016, 4014, 4012, 4010, 
4008, 4006, 4003, 4001, 3999, 3997, 3995, 3993, 3990, 3986, 
3980, 3973, 3967, 3960, 3954, 3947, 3941, 3934, 3928, 3921, 
3915, 3908, 3902, 3895, 3889, 3882, 3876, 3869, 3863, 3856, 
3849, 3843, 3836, 3830, 3823, 3817, 3810, 3804, 3797, 3791, 
3784, 3778, 3774, 3771, 3767, 3764, 3761, 3758, 3754, 3751, 
3748, 3744, 3741, 3738, 3735, 3731, 3728, 3725, 3722, 3718, 
3715, 3712, 3709, 3705, 3702, 3699, 3696, 3692, 3689, 3686, 
3683, 3679, 3676, 3673, 3670, 3666, 3663, 3660, 3657, 3653, 
3650, 3647, 3643, 3640, 3637, 3634, 3630, 3627, 3624, 3621, 
3617, 3612, 3605, 3599, 3592, 3585, 3579, 3572, 3566, 3559, 
3553, 3546, 3540, 3533, 3527, 3520, 3514, 3509, 3506, 3502, 
3499, 3496, 3493, 3489, 3486, 3483, 3480, 3476, 3473, 3470, 
3466, 3463, 3460, 3457, 3455, 3454, 3452, 3450, 3449, 3447, 
3446, 3444, 3442, 3441, 3439, 3437, 3436, 3434, 3432, 3431, 
3215, 3202, 3189, 3172, 3156, 3140, 3123, 3107, 3091, 3074, 
3058, 3042, 3026, 3009, 2993, 2977, 2960, 2944, 2928, 2912, 
2895, 2879, 2863, 2846, 2830, 2814, 2798, 2781, 2765, 2749, 
};


//TV3 T=376ms, 160 lpm
static const short  tv3_data[] = {
1975, 1975, 1975, 1975, 1975, 1975, 1975, 1975, 1975, 1975,  
1975, 1975, 1975, 1975, 1975, 1975, 2114, 2275, 2475, 2530,
2560, 2605, 2650, 2695, 2740, 2785, 2838, 2892, 2946, 2998,
3034, 3034, 3034, 3034, 3034, 3034, 3034, 3034, 3034, 3034, 
3034, 3071, 3107, 3144, 3180, 3217, 3253, 3292, 3337, 3382,
3427, 3466, 3494, 3523, 3551, 3582, 3618, 3655, 3692, 3721,
3731, 3741, 3751, 3761, 3771, 3781, 3791, 3801, 3809, 3816,
3822, 3829, 3835, 3842, 3849, 3855, 3862, 3868, 3875, 3882,
3888, 3895, 3901, 3908, 3915, 3921, 3925, 3928, 3931, 3934,
3938, 3941, 3944, 3947, 3951, 3954, 3957, 3960, 3964, 3967,
3970, 3973, 3977, 3980, 3982, 3985, 3988, 3990, 3993, 3996,
3998, 4001, 4003, 4006, 4009, 4011, 4014, 4016, 4019, 4022,
4024, 4027, 4029, 4032, 4035, 4037, 4040, 4044, 4047, 4050,
4054, 4057, 4060, 4063, 4067, 4070, 4073, 4076, 4080, 4083,
4086, 4089, 4093, 4090, 4080, 4071,
4061, 4052, 4043, 4033, 4024, 4015, 4006, 4000, 3994, 3987,
3981, 3975, 3968, 3962, 3956, 3950, 3943, 3937, 3931, 3924,
3918, 3912, 3905, 3899, 3893, 3886, 3880, 3874, 3868, 3861,
3855, 3849, 3842, 3836, 3830, 3823, 3817, 3811, 3804, 3798,
3792, 3786, 3779, 3773, 3767, 3760, 3754, 3748, 3741, 3735,
3729, 3722, 3659, 3653, 3647, 3640, 3634, 3628, 3621, 3615,
3609, 3603, 3596, 3590, 3584, 3577, 3571, 3565, 3558, 3552,
3546, 3537, 3528, 3519, 3509, 3500, 3491, 3481, 3472, 3463,
3454, 3448, 3442, 3435, 3429, 3423, 3416, 3410, 3404, 3398,
3391, 3385, 3379, 3372, 3366, 3360, 3353, 3347, 3341, 3324,
3305, 3287, 3269, 3252, 3243, 3233, 3224, 3215, 3205, 3196,
3187, 3177, 3168, 3094, 3070, 3047, 3023, 3000, 2985, 2976,
2967, 2957, 2948, 2939, 2929, 2920, 2911, 2817, 2799, 2780,
2762, 2744, 2669, 2549, 2536, 2524, 2512, 2499, 2252, 2117,
2111, 2104, 2098, 2092, 2065, 2036, 2007, 1978, 1949, 1713,
1700, 1688, 1676, 1663, 1559, 1281, 1238, 1225, 1213, 1201,
1142, 1088, 1070, 1052, 1033, 1003, 908, 879, 850, 821,
792, 587, 485, 473, 460, 448, 436, 418, 400, 382,
364, 309, 246, 228, 210, 192, 171, 74, 56, 38,
20, 2, 25, 53, 82, 110, 223, 357, 491, 309,
366, 631, 726, 665, 760, 856, 865, 769, 950, 1132,
1024, 1188, 1353, 1420, 1270, 1452, 1633, 1570, 1634, 1697,
1761, 1775, 1789, 1802, 1816,1900, 1975
};


// *** FV
// 250 lpm (media). Puede tardar en detectar esta fc...
static const short  fv1_data[] = {
2487, 2599, 2711, 2822, 2934, 3007, 3043, 3079, 3116, 3152, 
3180, 3207, 3234, 3261, 3288, 3315, 3342, 3370, 3397, 3413, 
3425, 3436, 3448, 3460, 3472, 3484, 3465, 3438, 3411, 3384, 
3358, 3331, 3304, 3277, 3250, 3225, 3201, 3177, 3153, 3129, 
3105, 3081, 3047, 3000, 2952, 2905, 2858, 2810, 2763, 2724, 
2700, 2677, 2653, 2629, 2605, 2581, 2549, 2501, 2454, 2407, 
2359, 2312, 2265, 2223, 2196, 2169, 2143, 2116, 2089, 2062, 
2035, 2008, 1982, 1914, 1844, 1773, 1703, 1632, 1562, 1492, 
1464, 1446, 1428, 1410, 1394, 1394, 1394, 1394, 1394, 1394, 
1394, 1394, 1393, 1393, 1425, 1461, 1497, 1534, 1570, 1606, 
1643, 1670, 1697, 1724, 1751, 1778, 1806, 1833, 1860, 1887, 
1893, 1893, 1892, 1892, 1892, 1892, 1892, 1892, 1892, 1892, 
1892, 1892, 1892, 1891, 1891, 1891, 1891, 1891, 1891, 1891, 
1891, 1891, 1891, 1890, 1890, 1890, 1890, 1890, 1890, 1890, 
1961, 2072, 2158, 2204, 2249, 2295, 2340, 2386, 2373, 2314, 
2226, 2167, 2126, 2108, 2090, 2072, 2054, 2036, 2018, 2000, 
1982, 1965, 1950, 1936, 1921, 1907, 1893, 1878, 1864, 1849, 
1835, 1820, 1806, 1792, 1777, 1763, 1748, 1734, 1720, 1705, 
1691, 1676, 1662, 1647, 1633, 1616, 1598, 1580, 1571, 1562,
1553, 1544, 1526, 1508, 1490, 1481, 1472, 1463, 1454, 1436,
1418, 1400, 1391, 1382, 1373, 1364, 1346, 1328, 1310, 1301,
1298, 1310, 1322, 1346, 1370, 1394, 1406, 1418, 1430, 1442, 
1469, 1506, 1542, 1560, 1578, 1597, 1615, 1651, 1687, 1721,
1736, 1750, 1764, 1779, 1808, 1837, 1866, 1880, 1895, 1909,
1924, 1953, 1982, 2011, 2025, 2040, 2064, 2091, 2146, 2201,
2256, 2283, 2310, 2338, 2365, 2420, 2475, 2530, 2557, 2585,
2612, 2640, 2694, 2749, 2804, 2832, 2859, 2886, 2914, 2969,
3023, 3090, 3127, 3164, 3201, 3215, 3227, 3239, 3251, 3257,
3263, 3269, 3274, 3286, 3281, 3255, 3241, 3228, 3214, 3201, 
3174, 3147, 3120, 3107, 3094, 3080, 3067, 3038, 2985, 2932,
2905, 2878, 2852, 2825, 2772, 2719, 2666, 2639, 2613, 2586,
2559, 2517, 2482, 2446, 2428, 2410, 2393, 2375, 2356, 2338,
2320, 2311, 2302, 2293, 2284, 2266, 2248, 2230, 2221, 2212,
2205, 2205, 2205, 2205, 2205, 2205, 2204, 2201, 2197, 2190,
2183, 2179, 2176, 2172, 2168, 2165, 2154, 2146, 2139, 2136,
2132, 2128, 2125, 2108, 2072, 2036, 2018, 2001, 1983, 1965,
1929, 1894, 1869, 1869, 1869, 1869, 1869, 1869, 1868, 1868,
1868, 1868, 1868, 1868, 1868, 1868, 1868, 1868, 1868, 1868,
1868, 1868, 1867, 1867, 1867, 1867, 1867, 1867, 1867, 1867,
1867, 1867, 1870, 1873, 1877, 1884, 1891, 1898, 1902, 1906,
1909, 1913, 1920, 1927, 1934, 1938, 1941, 1945, 1948, 1980,
2017, 2053, 2071, 2089, 2108, 2126, 2162, 2198, 2226, 2239,
2253, 2266, 2280, 2307, 2334, 2361, 2375, 2388, 2402, 2416, 
2443, 2449, 2448, 2448, 2448, 2448, 2448, 2448, 2448, 2448,
2448, 2448, 2448, 2448, 2433, 2405, 2376, 2362, 2348, 2333,
2319, 2290, 2262, 2233, 2219, 2204, 2190, 2176, 2147, 2119,
2091, 2078, 2065, 2051, 2038, 2011, 1984, 1957, 1944, 1930,
1917, 1903, 1877, 1846, 1810, 1792, 1775, 1757, 1739, 1703,
1668, 1632, 1614, 1596, 1578, 1561, 1525, 1489, 1454, 1436,
1418, 1400, 1382, 1347, 1311, 1275, 1257, 1240, 1222, 1204, 
1184, 1172, 1160, 1154, 1148, 1142, 1136, 1124, 1112, 1108,
1108, 1108, 1108, 1108, 1107, 1107, 1107, 1107, 1107, 1107,
1107, 1107, 1116, 1137, 1148, 1159, 1170, 1181, 1202, 1224,
1245, 1256, 1267, 1278, 1289, 1310, 1332, 1354, 1384, 1421,
1458, 1495, 1568, 1642, 1707, 1731, 1755, 1780, 1804, 1853,
1901, 1950, 1974, 1999, 2023, 2054, 2115, 2176, 2237, 2267,
2298, 2328, 2359, 2420, 2502, 2595, 2641, 2687, 2734, 2780, 
2876, 2988, 3100, 3155, 3211, 3267, 3323, 3391, 3440, 3488,
3513, 3537, 3561, 3586, 3634, 3683, 3690, 3690, 3690, 3690,
3690, 3690, 3690, 3690, 3690, 3690, 3690, 3690, 3690, 3640,
3553, 3509, 3465, 3421, 3378, 3290, 3163, 3026, 2957, 2912,
2877, 2842, 2771, 2701, 2631, 2595, 2560, 2525, 2490, 2425,
2377, 2330, 2306, 2283, 2259, 2235, 2188, 2141, 2091, 2062,
2032, 2003, 1973, 1915, 1856, 1797, 1767, 1738, 1708, 1679, 
1626, 1573, 1520, 1493, 1467, 1440, 1414, 1360, 1307, 1254,
1227, 1201, 1163, 1094, 956, 830, 749, 667, 585, 
503, 421, 339, 260, 225, 189, 153, 118, 82, 46, 12, 11, 11, 11, 11, 
11, 11, 18, 130, 242, 291, 327, 364, 400, 433, 458, 482, 506, 530, 554, 
578, 606, 643, 686, 877, 
1068, 1224, 1375, 1450, 1677, 1845, 2036, 2217, 2368, 2518, 
2669, 2820, 2897, 2958, 3019,3080, 3141, 3202, 3264, 3337, 
3411, 3484, 3558, 3614, 3650,3687, 3723, 3759, 3796, 3832,
3850, 3856, 3862, 3868, 3874, 3880, 3886, 3892, 3897, 3903, 
3909, 3915, 3921, 3927, 3981, 4054, 4080, 4044, 4009, 3973, 
3937, 3902, 3866, 3803, 3699, 3594, 3490, 3385, 3291, 3203, 
3116, 3028, 2941, 2877, 2818, 2759, 2700, 2641, 2582, 2523, 
2407, 2269, 2112, 1910, 1708, 1288, 1217, 1147, 1077, 1006, 
947, 888, 829, 770, 711,652, 593, 542, 493, 443,
393, 344, 294, 244, 195,145, 95, 46, 32, 61, 90, 119, 
148, 177, 206, 235, 264, 293, 322, 391, 484, 576,
669, 774, 965, 1156, 1347,1538, 1654, 1747, 1839, 1932,
2023, 2109, 2195, 2281, 2368,2454, 2540, 2648, 2779, 2911, 
3042, 3171, 3232, 3293, 3354, 3415, 3476, 3537, 3601, 3674, 
3748, 3821, 3895, 3925, 3934, 3943, 3951, 3960, 3969, 3978, 
3987, 3996, 3971, 3901, 3830, 3760, 3689, 3655, 3637, 3619, 
3601, 3583, 3565, 3547, 3529, 3511, 3479, 3420, 3361, 3302, 
3243, 3184, 3125, 3046, 2908, 2771, 2633, 2495, 2385, 2314, 
2244, 2173, 2103, 2033, 1962, 1897, 1843, 1790, 1737, 1684, 
1631, 1578, 1524, 1471, 1418, 1360, 1301, 1242, 1183, 1124, 
1065, 1006, 981, 966, 952, 937, 923, 909, 894, 880, 
865, 851, 836, 824, 833, 842, 851, 860, 869, 878, 
887, 896, 905, 957, 1018, 1079, 1140, 1202, 1263, 1324, 
1378, 1433, 1488, 1543, 1606, 1680, 1754, 1827, 1901, 1974, 
2048, 2122, 2195, 2264, 2325, 2386, 2447, 2508, 2569, 2630, 
2699, 2772, 2823, 2823, 2823, 2823, 2823, 2811, 2793, 2775, 
2757, 2739, 2686, 2633, 2579, 2526, 2478, 2442, 2407, 2371 
};

static const short  fv2_data[] = {
746, 813, 880, 912, 934, 954, 970, 986, 1002, 1019, 
1027, 1034, 1041, 1039, 1023, 1007, 991, 975, 960, 945, 
931, 914, 885, 857, 828, 810, 795, 781, 764, 736, 
707, 679, 658, 642, 626, 610, 594, 553, 510, 468, 
439, 428, 418, 418, 418, 418, 417, 427, 449, 471, 
492, 509, 525, 541, 558, 567, 567, 567, 567, 567, 
567, 567, 567, 567, 567, 567, 567, 567, 567, 567, 
588, 647, 674, 702, 711, 667, 637, 627, 616, 605, 
594, 585, 576, 567, 559, 550, 541, 533, 524, 516, 
507, 498, 489, 479, 471, 465, 457, 447, 441, 436, 
425, 417, 411, 403, 393, 389, 396, 411, 421, 429, 
440, 462, 473, 484, 506, 520, 529, 542, 559, 568, 
577, 594, 607, 619, 643, 676, 693, 709, 742, 767, 
783, 808, 841, 857, 874, 906, 938, 960, 968, 975, 
978, 982, 984, 972, 964, 952, 936, 928, 920, 895, 
871, 855, 831, 799, 783, 767, 744, 728, 717, 706, 
696, 690, 685, 674, 666, 661, 661, 661, 661, 659, 
654, 652, 650, 646, 641, 639, 637, 621, 605, 594, 
578, 560, 560, 560, 560, 560, 560, 560, 560, 560, 
560, 560, 560, 560, 560, 560, 561, 563, 567, 570, 
572, 576, 580, 582, 584, 605, 621, 632, 648, 667, 
675, 684, 700, 712, 720, 732, 734, 734, 734, 734, 
734, 734, 729, 712, 704, 695, 678, 665, 657, 644, 
627, 619, 611, 595, 583, 575, 563, 543, 532, 521, 
500, 484, 473, 457, 436, 425, 414, 393, 377, 366, 
355, 348, 344, 340, 333, 332, 332, 332, 332, 332, 
332, 334, 344, 351, 360, 373, 380, 386, 399, 415, 
437, 470, 512, 526, 541, 570, 592, 606, 634, 671, 
689, 707, 750, 792, 820, 862, 930, 963, 996, 1032, 
1053, 1068, 1090, 1107, 1107, 1107, 1107, 1107, 1107, 1107, 
1065, 1039, 1013, 948, 887, 863, 831, 789, 768, 747, 
713, 691, 677, 656, 627, 609, 591, 556, 530, 512, 
487, 456, 440, 424, 392, 368, 348, 286, 224, 175, 
126, 78, 56, 118, 46, 11, 11, 11, 18, 72, 
98, 120, 137, 151, 166, 181, 205, 320, 412, 503, 
610, 710, 800, 869, 905, 942, 979, 1023, 1067, 1095, 
1116, 1138, 1155, 1158, 1162, 1165, 1169, 1172, 1176, 1194, 
1224, 1202, 1181, 1159, 1109, 1047, 987, 934, 882, 845, 
810, 774, 722, 633, 512, 365, 323, 284, 248, 213, 
177, 147, 117, 88, 58, 95, 32, 90, 148, 61, 
79, 96, 145, 200, 289, 404, 496, 551, 606, 658, 
710, 762, 833, 912, 969, 1006, 1042, 1080, 1124, 1168, 
1180, 1185, 1190, 1196, 1191, 1149, 1106, 1091, 1080, 1069, 
1058, 1043, 1008, 972, 937, 872, 789, 715, 673, 630, 
588, 552, 521, 489, 457, 425, 390, 354, 319, 294, 
285, 276, 268, 259, 250, 249, 255, 260, 266, 271, 
305, 342, 378, 413, 446, 481, 526, 570, 614, 658, 
697, 734, 770, 809, 846, 846, 846, 837, 827, 805, 
773, 743, 722
};

//*** PVC (Premature Ventricular Contraction)
//*** Extrasístole ventricular
static const short  pvc_data[] = {
963, 962, 961, 960, 958, 957, 955, 953, 
951, 950, 948, 946, 945, 943, 941, 938, 934, 930, 
927, 923, 919, 915, 905, 893, 882, 873, 864, 855, 
840, 787, 791, 743, 694, 646, 650, 536, 576, 435, 
414, 348, 285, 223, 202, 105, 122, 60, 39, 30, 
21, 12, 6, 4, 3, 1, 0, 10, 24, 36, 
46, 56, 65, 75, 89, 105, 122, 146, 170, 287, 
301, 315, 328, 342, 387, 401, 414, 428, 442, 489, 
510, 531, 554, 578, 602, 628, 654, 712, 731, 749, 
768, 787, 807, 828, 849, 870, 892, 914, 938, 961, 
978, 994, 1013, 1034, 1055, 1069, 1083, 1096, 1110, 1124, 
1137, 1151, 1159, 1164, 1170, 1176, 1182, 1187, 1193, 1198, 
1204, 1208, 1210, 1212, 1214, 1216, 1218, 1220, 1221, 1222, 
1223, 1224, 1224, 1225, 1226, 1227, 1227, 1228, 1228, 1228, 
1228, 1228, 1228, 1228, 1228, 1228, 1228, 1228, 1228, 1228, 
1228, 1225, 1219, 1214, 1211, 1208, 1206, 1203, 1200, 1197, 
1194, 1191, 1188, 1185, 1182, 1178, 1173, 1169, 1164, 1159, 
1154, 1148, 1142, 1136, 1130, 1124, 1118, 1112, 1107, 1104, 
1100, 1096, 1092, 1088, 1084, 1079, 1074, 1070, 1065, 1060, 
1055, 1050, 1047, 1044, 1041, 1038, 1031, 1019, 1009, 1004, 
999, 994, 989, 984, 979, 976, 973, 970, 963
};


//--------------------------------------------



/*
const short  pvc_data[] = {
3265, 3264, 3263, 3262, 3261, 3260, 3260, 3259, 3258, 3257, 
3256, 3255, 3254, 3253, 3252, 3251, 3250, 3249, 3248, 3247, 
3247, 3246, 3245, 3244, 3242, 3240, 3239, 3237, 3236, 3234, 
3233, 3231, 3229, 3228, 3226, 3225, 3223, 3222, 3220, 3218, 
3217, 3215, 3214, 3212, 3210, 3209, 3207, 3206, 3204, 3203, 
3201, 3198, 3196, 3193, 3190, 3187, 3184, 3181, 3178, 3175, 
3173, 3170, 3167, 3164, 3161, 3158, 3155, 3152, 3150, 3147, 
3144, 3141, 3138, 3135, 3129, 3122, 3116, 3109, 3103, 3096, 
3090, 3083, 3077, 3070, 3064, 3057, 3051, 3037, 3017, 2997, 
2977, 2957, 2942, 2927, 2912, 2897, 2882, 2867, 2852, 2837, 
2801, 2713, 2626, 2538, 2639, 2558, 2478, 2397, 2316, 2236, 
2155, 2074, 2168, 1978, 1788, 1598, 1920, 1686, 1452, 1329, 
1381, 1271, 1161, 1052, 950, 848, 746, 835, 674, 514, 
353, 510, 408, 306, 203, 146, 131, 116, 101, 86, 
71, 56, 41, 26, 20, 17, 15, 12, 10, 8, 
5, 3, 1, 12, 35, 58, 81, 104, 122, 138, 
154, 171, 187, 203, 219, 236, 252, 270, 297, 324, 
352, 379, 409, 449, 488, 527, 567, 689, 959, 982, 
1005, 1028, 1051, 1073, 1096, 1119, 1142, 1165, 1292, 1315, 
1338, 1361, 1383, 1406, 1429, 1452, 1475, 1498, 1631, 1666, 
1701, 1737, 1772, 1809, 1848, 1888, 1927, 1967, 2007, 2051, 
2094, 2137, 2180, 2324, 2374, 2406, 2437, 2468, 2499, 2531, 
2562, 2593, 2625, 2656, 2691, 2727, 2762, 2797, 2833, 2868, 
2903, 2939, 2974, 3010, 3049, 3088, 3128, 3167, 3206, 3234, 
3261, 3288, 3315, 3343, 3378, 3414, 3449, 3484, 3519, 3542, 
3565, 3587, 3610, 3633, 3656, 3679, 3702, 3724, 3747, 3770, 
3793, 3816, 3839, 3854, 3864, 3873, 3883, 3892, 3902, 3911, 
3921, 3930, 3940, 3949, 3959, 3968, 3978, 3987, 3996, 4006, 
4015, 4025, 4029, 4033, 4036, 4039, 4042, 4046, 4049, 4052, 
4055, 4059, 4062, 4065, 4068, 4071, 4073, 4074, 4075, 4077, 
4078, 4079, 4080, 4082, 4083, 4084, 4085, 4086, 4088, 4089, 
4090, 4091, 4093, 4094, 4095, 4095, 4095, 4095, 4095, 4095, 
4095, 4095, 4095, 4095, 4095, 4095, 4095, 4095, 4095, 4095, 
4095, 4095, 4095, 4095, 4095, 4095, 4095, 4095, 4095, 4095, 
4095, 4095, 4085, 4075, 4065, 4055, 4049, 4044, 4039, 4034, 
4029, 4024, 4020, 4015, 4010, 4005, 4000, 3995, 3990, 3986, 
3981, 3976, 3971, 3966, 3961, 3957, 3952, 3947, 3942, 3935, 
3927, 3920, 3913, 3905, 3898, 3891, 3883, 3876, 3866, 3857, 
3847, 3837, 3827, 3817, 3807, 3797, 3788, 3778, 3768, 3758, 
3748, 3738, 3729, 3719, 3709, 3699, 3693, 3686, 3680, 3673, 
3667, 3660, 3654, 3647, 3641, 3634, 3628, 3621, 3615, 3607, 
3599, 3591, 3583, 3575, 3567, 3558, 3550, 3542, 3534, 3526, 
3518, 3509, 3501, 3497, 3492, 3487, 3482, 3477, 3472, 3468, 
3463, 3458, 3438, 3417, 3397, 3377, 3364, 3356, 3348, 3340, 
3332, 3324, 3315, 3307, 3299, 3291, 3283, 3275, 3266, 3259, 
3254, 3249, 3244, 3239, 3235, 3230, 3225, 3220, 3215, 3210, 
3205, 3201, 3196, 3188, 3178, 3168, 3159, 3150, 3150, 3150, 
3150, 3150, 3150, 3150, 3150, 3150, 3150, 3155, 3159, 3164, 
3169, 3173, 3174, 3176, 3178, 3179, 3181, 3183, 3184, 3186, 
3188, 3189, 3191, 3192, 3194, 3195, 3195, 3195, 3195, 3195, 
3195, 3195, 3195, 3195, 3196, 3200, 3203, 3206, 3209, 3213, 
3216, 3219, 3222, 3225, 3229, 3232, 3235, 3238, 3241, 3244, 
3246, 3249, 3251, 3253, 3256, 3258, 3261, 3262, 3262, 3263, 
3263, 3263, 3263, 3263, 3263, 3263, 3263, 3263, 3263, 3263, 
3263, 3263, 3263, 3263, 3263, 3263, 3263, 3263, 3263, 3263, 
3263, 3263, 3263, 3263, 3263, 3263, 3264, 3264, 3264, 3264, 
3264, 3264, 3264, 3264, 3264, 3264, 3264, 3264, 3264, 3264, 
3264, 3264, 3264, 3264, 3264, 3264, 3264, 3264, 3264, 3264, 
3264, 3264, 3264, 3265, 3265, 3265, 3265, 3265, 3265, 3265, 
3265, 3265, 3265, 3265, 3265, 3265, 3265, 3265, 3265
};
*/


/*
const short  p1_data[] = {
939, 940, 941, 942, 944, 945, 946, 947, 951, 956, 
962, 967, 973, 978, 983, 989, 994, 1000, 1005, 1015, 
1024, 1034, 1043, 1053, 1062, 1075, 1087, 1100, 1112, 1121, 
1126, 1131, 1136, 1141, 1146, 1151, 1156, 1164, 1172, 1179, 
1187, 1194, 1202, 1209, 1216, 1222, 1229, 1235, 1241, 1248, 
1254, 1260, 1264, 1268, 1271, 1275, 1279, 1283, 1287, 1286, 
1284, 1281, 1279, 1276, 1274, 1271, 1268, 1266, 1263, 1261, 
1258, 1256, 1253, 1251, 1246, 1242, 1237, 1232, 1227, 1222, 
1218, 1215, 1211, 1207, 1203, 1199, 1195, 1191, 1184, 1178, 
1171, 1165, 1159, 1152, 1146, 1141, 1136, 1130, 1125, 1120, 
1115, 1110, 1103, 1096, 1088, 1080, 1073, 1065, 1057, 1049, 
1040, 1030, 1021, 1012, 1004, 995, 987, 982, 978, 974, 
970, 966, 963};

//*** Ritmo sinusal: Onda QRS1
//*********************************
const short  qrs1_data[] = {
963, 964, 965, 965, 965, 965, 965, 965, 
963, 960, 957, 954, 951, 947, 944, 941, 938, 932, 
926, 920, 913, 907, 901, 894, 885, 865, 820, 733, 
606, 555, 507, 632, 697, 752, 807, 896, 977, 1023, 
1069, 1127, 1237, 1347, 1457, 2085, 2246, 2474, 2549, 2595, 
2641, 2695, 3083, 3135, 3187, 3217, 3315, 3403, 3492, 3581, 
3804, 3847, 3890, 3798, 3443, 3453, 3297, 3053, 2819, 2810, 
2225, 2258, 1892, 1734, 1625, 998, 903, 355, 376, 203, 
30, 33, 61, 90, 119, 160, 238, 275, 292, 309, 
325, 343, 371, 399, 429, 484, 542, 602, 652, 703, 
758, 802, 838, 856, 875, 895, 917, 938, 967, 1016, 
1035, 1041, 1047, 1054, 1060, 1066, 1066, 1064, 1061, 1058, 
1056, 1053, 1051, 1048, 1046, 1043, 1041, 1038, 1035, 1033, 
1030, 1028, 1025, 1022, 1019, 1017, 1014, 1011, 1008, 1006, 
1003, 1001, 999, 998, 996, 994, 993, 991, 990, 988, 
986, 985, 983, 981, 978, 976, 973, 971, 968, 966, 
963, 963};

//*** Ritmo sinusal: Onda T1
//*********************************
const short  t1_data[] = {
963, 964, 965, 966, 967, 968, 969, 970, 971, 972, 974, 
976, 978, 980, 983, 985, 987, 989, 991, 993, 995, 
997, 999, 1002, 1006, 1011, 1015, 1019, 1023, 1028, 1032, 
1036, 1040, 1045, 1050, 1055, 1059, 1064, 1069, 1076, 1082, 
1088, 1095, 1101, 1107, 1114, 1120, 1126, 1132, 1141, 1149, 
1158, 1166, 1173, 1178, 1183, 1188, 1193, 1198, 1203, 1208, 
1214, 1221, 1227, 1233, 1240, 1246, 1250, 1254, 1259, 1263, 
1269, 1278, 1286, 1294, 1303, 1309, 1315, 1322, 1328, 1334, 
1341, 1343, 1345, 1347, 1349, 1351, 1353, 1355, 1357, 1359, 
1359, 1359, 1359, 1359, 1358, 1356, 1354, 1352, 1350, 1347, 
1345, 1343, 1341, 1339, 1336, 1334, 1332, 1329, 1327, 1324, 
1322, 1320, 1317, 1315, 1312, 1307, 1301, 1294, 1288, 1281, 
1275, 1270, 1265, 1260, 1256, 1251, 1246, 1240, 1233, 1227, 
1221, 1214, 1208, 1201, 1194, 1186, 1178, 1170, 1162, 1154, 
1148, 1144, 1140, 1136, 1131, 1127, 1123, 1118, 1114, 1107, 
1099, 1090, 1082, 1074, 1069, 1064, 1058, 1053, 1048, 1043, 
1038, 1034, 1029, 1025, 1021, 1017, 1013, 1009, 1005, 1001, 
997, 994, 990, 991, 992};
*/

/*
//*** Ritmo sinusal (onda completa)
//*********************************
const short  sinusal_data[] = {  
939, 940, 941, 942, 944, 945, 946, 947, 951, 956, 
962, 967, 973, 978, 983, 989, 994, 1000, 1005, 1015, 
1024, 1034, 1043, 1053, 1062, 1075, 1087, 1100, 1112, 1121, 
1126, 1131, 1136, 1141, 1146, 1151, 1156, 1164, 1172, 1179, 
1187, 1194, 1202, 1209, 1216, 1222, 1229, 1235, 1241, 1248, 
1254, 1260, 1264, 1268, 1271, 1275, 1279, 1283, 1287, 1286, 
1284, 1281, 1279, 1276, 1274, 1271, 1268, 1266, 1263, 1261, 
1258, 1256, 1253, 1251, 1246, 1242, 1237, 1232, 1227, 1222, 
1218, 1215, 1211, 1207, 1203, 1199, 1195, 1191, 1184, 1178, 
1171, 1165, 1159, 1152, 1146, 1141, 1136, 1130, 1125, 1120, 
1115, 1110, 1103, 1096, 1088, 1080, 1073, 1065, 1057, 1049, 
1040, 1030, 1021, 1012, 1004, 995, 987, 982, 978, 974, 
970, 966, 963, 959, 955, 952, 949, 945, 942, 939, 
938, 939, 940, 941, 943, 944, 945, 946, 946, 946, 
946, 946, 946, 946, 946, 947, 950, 952, 954, 956, 
958, 960, 962, 964, 965, 965, 965, 965, 965, 965, 
963, 960, 957, 954, 951, 947, 944, 941, 938, 932, 
926, 920, 913, 907, 901, 894, 885, 865, 820, 733, 
606, 555, 507, 632, 697, 752, 807, 896, 977, 1023, 
1069, 1127, 1237, 1347, 1457, 2085, 2246, 2474, 2549, 2595, 
2641, 2695, 3083, 3135, 3187, 3217, 3315, 3403, 3492, 3581, 
3804, 3847, 3890, 3798, 3443, 3453, 3297, 3053, 2819, 2810, 
2225, 2258, 1892, 1734, 1625, 998, 903, 355, 376, 203, 
30, 33, 61, 90, 119, 160, 238, 275, 292, 309, 
325, 343, 371, 399, 429, 484, 542, 602, 652, 703, 
758, 802, 838, 856, 875, 895, 917, 938, 967, 1016, 
1035, 1041, 1047, 1054, 1060, 1066, 1066, 1064, 1061, 1058, 
1056, 1053, 1051, 1048, 1046, 1043, 1041, 1038, 1035, 1033, 
1030, 1028, 1025, 1022, 1019, 1017, 1014, 1011, 1008, 1006, 
1003, 1001, 999, 998, 996, 994, 993, 991, 990, 988, 
986, 985, 983, 981, 978, 976, 973, 971, 968, 966, 
963, 963, 963, 963, 963, 963, 963, 963, 963, 963, 
963, 963, 963, 963, 963, 963, 963, 963, 963, 963, 
964, 965, 966, 967, 968, 969, 970, 971, 972, 974, 
976, 978, 980, 983, 985, 987, 989, 991, 993, 995, 
997, 999, 1002, 1006, 1011, 1015, 1019, 1023, 1028, 1032, 
1036, 1040, 1045, 1050, 1055, 1059, 1064, 1069, 1076, 1082, 
1088, 1095, 1101, 1107, 1114, 1120, 1126, 1132, 1141, 1149, 
1158, 1166, 1173, 1178, 1183, 1188, 1193, 1198, 1203, 1208, 
1214, 1221, 1227, 1233, 1240, 1246, 1250, 1254, 1259, 1263, 
1269, 1278, 1286, 1294, 1303, 1309, 1315, 1322, 1328, 1334, 
1341, 1343, 1345, 1347, 1349, 1351, 1353, 1355, 1357, 1359, 
1359, 1359, 1359, 1359, 1358, 1356, 1354, 1352, 1350, 1347, 
1345, 1343, 1341, 1339, 1336, 1334, 1332, 1329, 1327, 1324, 
1322, 1320, 1317, 1315, 1312, 1307, 1301, 1294, 1288, 1281, 
1275, 1270, 1265, 1260, 1256, 1251, 1246, 1240, 1233, 1227, 
1221, 1214, 1208, 1201, 1194, 1186, 1178, 1170, 1162, 1154, 
1148, 1144, 1140, 1136, 1131, 1127, 1123, 1118, 1114, 1107, 
1099, 1090, 1082, 1074, 1069, 1064, 1058, 1053, 1048, 1043, 
1038, 1034, 1029, 1025, 1021, 1017, 1013, 1009, 1005, 1001, 
997, 994, 990, 991, 992, 994, 996, 997, 999, 998, 
997, 996, 995, 994, 993, 991, 990, 989, 989, 989, 
989, 989, 989, 989, 988, 986, 984, 983, 981, 980, 
982, 984, 986, 988, 990, 993, 995, 997, 999, 1002, 
1005, 1008, 1012}; 
*/
