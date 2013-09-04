IMPORT CellFormatter.CellFormatter;

CarsRecord := RECORD
    VARSTRING name;
    INTEGER economy_mpg;
    INTEGER cylinders;
    INTEGER displacement_cc;
    INTEGER power_hp;
    INTEGER weight_lb;
    INTEGER _0_60_mph_s;
    INTEGER year;
END;

CarsDataset := DATASET([
        {'AMC Ambassador Brougham', 13, 8, 360, 175, 3821, 11, 73},{'AMC Ambassador DPL', 15, 8, 390, 190, 3850, 8, 70},{'AMC Ambassador SST', 17, 8, 304, 150, 3672, 11, 72},{'AMC Concord DL 6', 20, 6, 232, 90, 3265, 18, 79},{'AMC Concord DL', 18, 6, 258, 120, 3410, 15, 78},{'AMC Concord DL', 23, 4, 151, 0, 3035, 20, 82},{'AMC Concord', 19, 6, 232, 90, 3210, 17, 78},{'AMC Concord', 24, 4, 151, 90, 3003, 20, 80},{'AMC Gremlin', 18, 6, 232, 100, 2789, 15, 73},{'AMC Gremlin', 19, 6, 232, 100, 2634, 13, 71},{'AMC Gremlin', 20, 6, 232, 100, 2914, 16, 75},{'AMC Gremlin', 21, 6, 199, 90, 2648, 15, 70},{'AMC Hornet Sportabout (Wagon)', 18, 6, 258, 110, 2962, 13, 71},{'AMC Hornet', 18, 6, 199, 97, 2774, 15, 70},{'AMC Hornet', 18, 6, 232, 100, 2945, 16, 73},{'AMC Hornet', 19, 6, 232, 100, 2901, 16, 74},{'AMC Hornet', 22, 6, 232, 90, 3085, 17, 76},{'AMC Matador (Wagon)', 14, 8, 304, 150, 4257, 15, 74},{'AMC Matador (Wagon)', 15, 8, 304, 150, 3892, 12, 72},{'AMC Matador', 14, 8, 304, 150, 3672, 11, 73},{'AMC Matador', 15, 6, 258, 110, 3730, 19, 75},{'AMC Matador', 15, 8, 304, 120, 3962, 13, 76},{'AMC Matador', 16, 6, 258, 110, 3632, 18, 74},{'AMC Matador', 18, 6, 232, 100, 3288, 15, 71},{'AMC Pacer D/L', 17, 6, 258, 95, 3193, 17, 76},{'AMC Pacer', 19, 6, 232, 90, 3211, 17, 75},{'AMC Rebel SST (Wagon)', 0, 8, 360, 175, 3850, 11, 70},{'AMC Rebel SST', 16, 8, 304, 150, 3433, 12, 70},{'AMC Spirit DL', 27, 4, 121, 80, 2670, 15, 79},{'Audi 100 LS', 20, 4, 114, 91, 2582, 14, 73},{'Audi 100 LS', 23, 4, 115, 95, 2694, 15, 75},{'Audi 100 LS', 24, 4, 107, 90, 2430, 14, 70},{'Audi 4000', 34, 4, 97, 78, 2188, 15, 80},{'Audi 5000', 20, 5, 131, 103, 2830, 15, 78},{'Audi 5000S (Diesel)', 36, 5, 121, 67, 2950, 19, 80},{'Audi Fox', 29, 4, 98, 83, 2219, 16, 74},{'BMW 2002', 26, 4, 121, 113, 2234, 12, 70},{'BMW 320i', 21, 4, 121, 110, 2600, 12, 77},{'Buick Century 350', 13, 8, 350, 175, 4100, 13, 73},{'Buick Century Limited', 25, 6, 181, 110, 2945, 16, 82},{'Buick Century Luxus (Wagon)', 13, 8, 350, 150, 4699, 14, 74},{'Buick Century Special', 20, 6, 231, 105, 3380, 15, 78},{'Buick Century', 17, 6, 231, 110, 3907, 21, 75},{'Buick Century', 22, 6, 231, 110, 3415, 15, 81},{'Buick Electra 225 Custom', 12, 8, 455, 225, 4951, 11, 73},{'Buick Estate Wagon (Wagon)', 14, 8, 455, 225, 3086, 10, 70},{'Buick Estate Wagon (Wagon)', 16, 8, 350, 155, 4360, 14, 79},{'Buick Lesabre Custom', 13, 8, 350, 155, 4502, 13, 72},{'Buick Opel Isuzu Deluxe', 30, 4, 111, 80, 2155, 14, 77},{'Buick Regal Sport Coupe (Turbo)', 17, 6, 231, 165, 3445, 13, 78},{'Buick Skyhawk', 21, 6, 231, 110, 3039, 15, 75},{'Buick Skylark 320', 15, 8, 350, 165, 3693, 11, 70},{'Buick Skylark Limited', 28, 4, 151, 90, 2670, 16, 79},{'Buick Skylark', 20, 6, 231, 105, 3425, 16, 77},{'Buick Skylark', 26, 4, 151, 84, 2635, 16, 81},{'Cadillac Eldorado', 23, 8, 350, 125, 3900, 17, 79},{'Cadillac Seville', 16, 8, 350, 180, 4380, 12, 76},{'Chevroelt Chevelle Malibu', 16, 6, 250, 105, 3897, 18, 75},{'Chevrolet Bel Air', 15, 8, 350, 145, 4440, 14, 75},{'Chevrolet Camaro', 27, 4, 151, 90, 2950, 17, 82},{'Chevrolet Caprice Classic', 13, 8, 400, 150, 4464, 12, 73},{'Chevrolet Caprice Classic', 17, 8, 305, 130, 3840, 15, 79},{'Chevrolet Caprice Classic', 17, 8, 305, 145, 3880, 12, 77},{'Chevrolet Cavalier 2-Door', 34, 4, 112, 88, 2395, 18, 82},{'Chevrolet Cavalier Wagon', 27, 4, 112, 88, 2640, 18, 82},{'Chevrolet Cavalier', 28, 4, 112, 88, 2605, 19, 82},{'Chevrolet Chevelle Concours (Wagon)', 0, 8, 350, 165, 4142, 11, 70},{'Chevrolet Chevelle Concours (Wagon)', 13, 8, 307, 130, 4098, 14, 72},{'Chevrolet Chevelle Malibu Classic', 16, 6, 250, 100, 3781, 17, 74},{'Chevrolet Chevelle Malibu Classic', 17, 8, 305, 140, 4215, 13, 76},{'Chevrolet Chevelle Malibu', 17, 6, 250, 100, 3329, 15, 71},{'Chevrolet Chevelle Malibu', 18, 8, 307, 130, 3504, 12, 70},{'Chevrolet Chevette', 29, 4, 85, 52, 2035, 22, 76},{'Chevrolet Chevette', 30, 4, 98, 68, 2155, 16, 78},{'Chevrolet Chevette', 30, 4, 98, 63, 2051, 17, 77},{'Chevrolet Chevette', 32, 4, 98, 70, 2120, 15, 80},{'Chevrolet Citation', 23, 6, 173, 110, 2725, 12, 81},{'Chevrolet Citation', 28, 4, 151, 90, 2678, 16, 80},{'Chevrolet Citation', 28, 6, 173, 115, 2595, 11, 79},{'Chevrolet Concours', 17, 6, 250, 110, 3520, 16, 77},{'Chevrolet Impala', 11, 8, 400, 150, 4997, 14, 73},{'Chevrolet Impala', 13, 8, 350, 165, 4274, 12, 72},{'Chevrolet Impala', 14, 8, 350, 165, 4209, 12, 71},{'Chevrolet Impala', 14, 8, 454, 220, 4354, 9, 70},{'Chevrolet Malibu Classic (Wagon)', 19, 8, 267, 125, 3605, 15, 79},{'Chevrolet Malibu', 13, 8, 350, 145, 3988, 13, 73},{'Chevrolet Malibu', 20, 6, 200, 95, 3155, 18, 78},{'Chevrolet Monte Carlo Landau', 15, 8, 350, 170, 4165, 11, 77},{'Chevrolet Monte Carlo Landau', 19, 8, 305, 145, 3425, 13, 78},{'Chevrolet Monte Carlo S', 15, 8, 350, 145, 4082, 13, 73},{'Chevrolet Monte Carlo', 15, 8, 400, 150, 3761, 9, 70},{'Chevrolet Monza 2+2', 20, 8, 262, 110, 3221, 13, 75},{'Chevrolet Nova Custom', 16, 6, 250, 100, 3278, 18, 73},{'Chevrolet Nova', 15, 6, 250, 100, 3336, 17, 74},{'Chevrolet Nova', 18, 6, 250, 105, 3459, 16, 75},{'Chevrolet Nova', 22, 6, 250, 105, 3353, 14, 76},{'Chevrolet Vega (Wagon)', 22, 4, 140, 72, 2408, 19, 71},{'Chevrolet Vega 2300', 28, 4, 140, 90, 2264, 15, 71},{'Chevrolet Vega', 20, 4, 140, 90, 2408, 19, 72},{'Chevrolet Vega', 21, 4, 140, 72, 2401, 19, 73},{'Chevrolet Vega', 25, 4, 140, 75, 2542, 17, 74},{'Chevrolet Woody', 24, 4, 98, 60, 2164, 22, 76},{'Chevy C10', 13, 8, 350, 145, 4055, 12, 76},{'Chevy C20', 10, 8, 307, 200, 4376, 15, 70},{'Chevy S-10', 31, 4, 119, 82, 2720, 19, 82},{'Chrysler Cordoba', 15, 8, 400, 190, 4325, 12, 77},{'Chrysler Lebaron Medallion', 26, 4, 156, 92, 2585, 14, 82},{'Chrysler Lebaron Salon', 17, 6, 225, 85, 3465, 16, 81},{'Chrysler Lebaron Town & Country (Wagon)', 18, 8, 360, 150, 3940, 13, 79},{'Chrysler New Yorker Brougham', 13, 8, 440, 215, 4735, 11, 73},{'Chrysler Newport Royal', 13, 8, 400, 190, 4422, 12, 72},{'Citroen DS-21 Pallas', 0, 4, 133, 115, 3090, 17, 70},{'Datsun 1200', 35, 4, 72, 69, 1613, 18, 71},{'Datsun 200SX', 23, 4, 119, 97, 2405, 14, 78},{'Datsun 200SX', 32, 4, 119, 100, 2615, 14, 81},{'Datsun 210', 31, 4, 85, 65, 2020, 19, 79},{'Datsun 210', 37, 4, 85, 65, 1975, 19, 81},{'Datsun 210', 40, 4, 85, 65, 2110, 19, 80},{'Datsun 280ZX', 32, 6, 168, 132, 2910, 11, 80},{'Datsun 310 GX', 38, 4, 91, 67, 1995, 16, 82},{'Datsun 310', 37, 4, 86, 65, 2019, 16, 80},{'Datsun 510 (Wagon)', 28, 4, 97, 92, 2288, 17, 72},{'Datsun 510 Hatchback', 37, 4, 119, 92, 2434, 15, 80},{'Datsun 510', 27, 4, 119, 97, 2300, 14, 78},{'Datsun 610', 22, 4, 108, 94, 2379, 16, 73},{'Datsun 710', 24, 4, 119, 97, 2545, 17, 75},{'Datsun 710', 32, 4, 83, 61, 2003, 19, 74},{'Datsun 810 Maxima', 24, 6, 146, 120, 2930, 13, 81},{'Datsun 810', 22, 6, 146, 97, 2815, 14, 77},{'Datsun B-210', 32, 4, 85, 70, 1990, 17, 76},{'Datsun B210 GX', 39, 4, 85, 70, 2070, 18, 78},{'Datsun B210', 31, 4, 79, 67, 1950, 19, 74},{'Datsun F-10 Hatchback', 33, 4, 85, 70, 1945, 16, 77},{'Datsun PL510', 27, 4, 97, 88, 2130, 14, 70},{'Datsun PL510', 27, 4, 97, 88, 2130, 14, 71},{'Dodge Aries SE', 29, 4, 135, 84, 2525, 16, 82},{'Dodge Aries Wagon (Wagon)', 25, 4, 156, 92, 2620, 14, 81},{'Dodge Aspen 6', 20, 6, 225, 110, 3360, 16, 79},{'Dodge Aspen SE', 20, 6, 225, 100, 3651, 17, 76},{'Dodge Aspen', 18, 6, 225, 110, 3620, 18, 78},{'Dodge Aspen', 19, 6, 225, 90, 3381, 18, 80},{'Dodge Challenger SE', 15, 8, 383, 170, 3563, 10, 70},{'Dodge Charger 2.2', 36, 4, 135, 84, 2370, 13, 82},{'Dodge Colt (Wagon)', 28, 4, 98, 80, 2164, 15, 72},{'Dodge Colt Hardtop', 25, 4, 97, 80, 2126, 17, 72},{'Dodge Colt Hatchback Custom', 35, 4, 98, 80, 1915, 14, 79},{'Dodge Colt M/M', 33, 4, 98, 83, 2075, 15, 77},{'Dodge Colt', 26, 4, 98, 79, 2255, 17, 76},{'Dodge Colt', 27, 4, 156, 105, 2800, 14, 80},{'Dodge Colt', 28, 4, 90, 75, 2125, 14, 74},{'Dodge Coronet Brougham', 16, 8, 318, 150, 4190, 13, 76},{'Dodge Coronet Custom (Wagon)', 14, 8, 318, 150, 4457, 13, 74},{'Dodge Coronet Custom', 15, 8, 318, 150, 3777, 12, 73},{'Dodge D100', 13, 8, 318, 150, 3755, 14, 76},{'Dodge D200', 11, 8, 318, 210, 4382, 13, 70},{'Dodge Dart Custom', 15, 8, 318, 150, 3399, 11, 73},{'Dodge Diplomat', 19, 8, 318, 140, 3735, 13, 78},{'Dodge Magnum XE', 17, 8, 318, 140, 4080, 13, 78},{'Dodge Monaco (Wagon)', 12, 8, 383, 180, 4955, 11, 71},{'Dodge Monaco Brougham', 15, 8, 318, 145, 4140, 13, 77},{'Dodge Omni', 30, 4, 105, 75, 2230, 14, 78},{'Dodge Rampage', 32, 4, 135, 84, 2295, 11, 82},{'Dodge St. Regis', 18, 8, 318, 135, 3830, 15, 79},{'Fiat 124 Sport Coupe', 26, 4, 98, 90, 2265, 15, 73},{'Fiat 124 TC', 26, 4, 116, 75, 2246, 14, 74},{'Fiat 124B', 30, 4, 88, 76, 2065, 14, 71},{'Fiat 128', 24, 4, 90, 75, 2108, 15, 74},{'Fiat 128', 29, 4, 68, 49, 1867, 19, 73},{'Fiat 131', 28, 4, 107, 86, 2464, 15, 76},{'Fiat Strada Custom', 37, 4, 91, 69, 2130, 14, 79},{'Fiat X1.9', 31, 4, 79, 67, 2000, 16, 74},{'Ford Capri II', 25, 4, 140, 92, 2572, 14, 76},{'Ford Country Squire (Wagon)', 13, 8, 400, 170, 4746, 12, 71},{'Ford Country Squire (Wagon)', 15, 8, 351, 142, 4054, 14, 79},{'Ford Country', 12, 8, 400, 167, 4906, 12, 73},{'Ford Escort 2H', 29, 4, 98, 65, 2380, 20, 81},{'Ford Escort 4W', 34, 4, 98, 65, 2045, 16, 81},{'Ford F108', 13, 8, 302, 130, 3870, 15, 76},{'Ford F250', 10, 8, 360, 215, 4615, 14, 70},{'Ford Fairmont (Auto)', 20, 6, 200, 85, 2965, 15, 78},{'Ford Fairmont (Man)', 25, 4, 140, 88, 2720, 15, 78},{'Ford Fairmont 4', 22, 4, 140, 88, 2890, 17, 79},{'Ford Fairmont Futura', 24, 4, 140, 92, 2865, 16, 82},{'Ford Fairmont', 26, 4, 140, 88, 2870, 18, 80},{'Ford Fiesta', 36, 4, 98, 66, 1800, 14, 78},{'Ford Futura', 18, 8, 302, 139, 3205, 11, 78},{'Ford Galaxie 500', 14, 8, 351, 153, 4129, 13, 72},{'Ford Galaxie 500', 14, 8, 351, 153, 4154, 13, 71},{'Ford Galaxie 500', 15, 8, 429, 198, 4341, 10, 70},{'Ford Gran Torino (Wagon)', 13, 8, 302, 140, 4294, 16, 72},{'Ford Gran Torino (Wagon)', 14, 8, 302, 140, 4638, 16, 74},{'Ford Gran Torino', 14, 8, 302, 137, 4042, 14, 73},{'Ford Gran Torino', 14, 8, 351, 152, 4215, 12, 76},{'Ford Gran Torino', 16, 8, 302, 140, 4141, 14, 74},{'Ford Granada Ghia', 18, 6, 250, 78, 3574, 21, 76},{'Ford Granada GL', 20, 6, 200, 88, 3060, 17, 81},{'Ford Granada L', 22, 6, 232, 112, 2835, 14, 82},{'Ford Granada', 18, 6, 250, 98, 3525, 19, 77},{'Ford LTD Landau', 17, 8, 302, 129, 3725, 13, 79},{'Ford LTD', 13, 8, 351, 158, 4363, 13, 73},{'Ford LTD', 14, 8, 351, 148, 4657, 13, 75},{'Ford Maverick', 15, 6, 250, 72, 3158, 19, 75},{'Ford Maverick', 18, 6, 250, 88, 3021, 16, 73},{'Ford Maverick', 21, 6, 200, 0, 2875, 17, 74},{'Ford Maverick', 21, 6, 200, 85, 2587, 16, 70},{'Ford Maverick', 24, 6, 200, 81, 3012, 17, 76},{'Ford Mustang Boss 302', 0, 8, 302, 140, 3353, 8, 70},{'Ford Mustang Cobra', 23, 4, 140, 0, 2905, 14, 80},{'Ford Mustang GL', 27, 4, 140, 86, 2790, 15, 82},{'Ford Mustang II 2+2', 25, 4, 140, 89, 2755, 15, 77},{'Ford Mustang II', 13, 8, 302, 129, 3169, 12, 75},{'Ford Mustang', 18, 6, 250, 88, 3139, 14, 71},{'Ford Pinto (Wagon)', 22, 4, 122, 86, 2395, 16, 72},{'Ford Pinto Runabout', 21, 4, 122, 86, 2226, 16, 72},{'Ford Pinto', 18, 6, 171, 97, 2984, 14, 75},{'Ford Pinto', 19, 4, 122, 85, 2310, 18, 73},{'Ford Pinto', 23, 4, 140, 83, 2639, 17, 75},{'Ford Pinto', 25, 4, 98, 0, 2046, 19, 71},{'Ford Pinto', 26, 4, 122, 80, 2451, 16, 74},{'Ford Pinto', 26, 4, 140, 72, 2565, 13, 76},{'Ford Ranger', 28, 4, 120, 79, 2625, 18, 82},{'Ford Thunderbird', 16, 8, 351, 149, 4335, 14, 77},{'Ford Torino (Wagon)', 0, 8, 351, 153, 4034, 11, 70},{'Ford Torino 500', 19, 6, 250, 88, 3302, 15, 71},{'Ford Torino', 17, 8, 302, 140, 3449, 10, 70},{'Hi 1200D', 9, 8, 304, 193, 4732, 18, 70},{'Honda Accord CVCC', 31, 4, 98, 68, 2045, 18, 77},{'Honda Accord LX', 29, 4, 98, 68, 2135, 16, 78},{'Honda Accord', 32, 4, 107, 72, 2290, 17, 80},{'Honda Accord', 36, 4, 107, 75, 2205, 14, 82},{'Honda Civic (Auto)', 32, 4, 91, 67, 1965, 15, 82},{'Honda Civic 1300', 35, 4, 81, 60, 1760, 16, 81},{'Honda Civic 1500 GL', 44, 4, 91, 67, 1850, 13, 80},{'Honda Civic CVCC', 33, 4, 91, 53, 1795, 17, 75},{'Honda Civic CVCC', 36, 4, 91, 60, 1800, 16, 78},{'Honda Civic', 24, 4, 120, 97, 2489, 15, 74},{'Honda Civic', 33, 4, 91, 53, 1795, 17, 76},{'Honda Civic', 38, 4, 91, 67, 1965, 15, 82},{'Honda Prelude', 33, 4, 107, 75, 2210, 14, 81},{'Maxda GLC Deluxe', 34, 4, 86, 65, 1975, 15, 79},{'Maxda RX-3', 18, 3, 70, 90, 2124, 13, 73},{'Mazda 626', 31, 4, 120, 75, 2542, 17, 80},{'Mazda 626', 31, 4, 120, 74, 2635, 18, 81},{'Mazda GLC 4', 34, 4, 91, 68, 1985, 16, 81},{'Mazda GLC Custom L', 37, 4, 91, 68, 2025, 18, 82},{'Mazda GLC Custom', 31, 4, 91, 68, 1970, 17, 82},{'Mazda GLC Deluxe', 32, 4, 78, 52, 1985, 19, 78},{'Mazda GLC', 46, 4, 86, 65, 2110, 17, 80},{'Mazda RX-2 Coupe', 19, 3, 70, 97, 2330, 13, 72},{'Mazda RX-4', 21, 3, 80, 110, 2720, 13, 77},{'Mazda RX-7 Gs', 23, 3, 70, 100, 2420, 12, 80},{'Mercedes-Benz 240D', 30, 4, 146, 67, 3250, 21, 80},{'Mercedes-Benz 280S', 16, 6, 168, 120, 3820, 16, 76},{'Mercedes-Benz 300D', 25, 5, 183, 77, 3530, 20, 79},{'Mercury Capri 2000', 23, 4, 122, 86, 2220, 14, 71},{'Mercury Capri V6', 21, 6, 155, 107, 2472, 14, 73},{'Mercury Cougar Brougham', 15, 8, 302, 130, 4295, 14, 77},{'Mercury Grand Marquis', 16, 8, 351, 138, 3955, 13, 79},{'Mercury Lynx L', 36, 4, 98, 70, 2125, 17, 82},{'Mercury Marquis Brougham', 12, 8, 429, 198, 4952, 11, 73},{'Mercury Marquis', 11, 8, 429, 208, 4633, 11, 72},{'Mercury Monarch Ghia', 20, 8, 302, 139, 3570, 12, 78},{'Mercury Monarch', 15, 6, 250, 72, 3432, 21, 75},{'Mercury Zephyr 6', 19, 6, 200, 85, 2990, 18, 79},{'Mercury Zephyr', 20, 6, 200, 85, 3070, 16, 78},{'Nissan Stanza XE', 36, 4, 120, 88, 2160, 14, 82},{'Oldsmobile Cutlass Ciera (Diesel)', 38, 6, 262, 85, 3015, 17, 82},{'Oldsmobile Cutlass LS', 26, 8, 350, 105, 3725, 19, 81},{'Oldsmobile Cutlass Salon Brougham', 19, 8, 260, 110, 3365, 15, 78},{'Oldsmobile Cutlass Salon Brougham', 23, 8, 260, 90, 3420, 22, 79},{'Oldsmobile Cutlass Supreme', 17, 8, 260, 110, 4060, 19, 77},{'Oldsmobile Delta 88 Royale', 12, 8, 350, 160, 4456, 13, 72},{'Oldsmobile Omega Brougham', 26, 6, 173, 115, 2700, 12, 79},{'Oldsmobile Omega', 11, 8, 350, 180, 3664, 11, 73},{'Oldsmobile Starfire SX', 23, 4, 151, 85, 2855, 17, 78},{'Oldsmobile Vista Cruiser', 12, 8, 350, 180, 4499, 12, 73},{'Opel 1900', 25, 4, 116, 81, 2220, 16, 76},{'Opel 1900', 28, 4, 116, 90, 2123, 14, 71},{'Opel Manta', 24, 4, 116, 75, 2158, 15, 73},{'Opel Manta', 26, 4, 97, 78, 2300, 14, 74},{'Peugeot 304', 30, 4, 79, 70, 2074, 19, 71},{'Peugeot 504 (Wagon)', 21, 4, 120, 87, 2979, 19, 72},{'Peugeot 504', 19, 4, 120, 88, 3270, 21, 76},{'Peugeot 504', 23, 4, 120, 88, 2957, 17, 75},{'Peugeot 504', 25, 4, 110, 87, 2672, 17, 70},{'Peugeot 504', 27, 4, 141, 71, 3190, 24, 79},{'Peugeot 505S Turbo Diesel', 28, 4, 141, 80, 3230, 20, 81},{'Peugeot 604SL', 16, 6, 163, 133, 3410, 15, 78},{'Plymouth Arrow GS', 25, 4, 122, 96, 2300, 15, 77},{'Plymouth Barracuda 340', 14, 8, 340, 160, 3609, 8, 70},{'Plymouth Champ', 39, 4, 86, 64, 1875, 16, 81},{'Plymouth Cricket', 26, 4, 91, 70, 1955, 20, 71},{'Plymouth Custom Suburb', 13, 8, 360, 170, 4654, 13, 73},{'Plymouth Duster', 20, 6, 198, 95, 3102, 16, 74},{'Plymouth Duster', 22, 6, 198, 95, 2833, 15, 70},{'Plymouth Duster', 23, 6, 198, 95, 2904, 16, 73},{'Plymouth Fury Gran Sedan', 14, 8, 318, 150, 4237, 14, 73},{'Plymouth Fury III', 14, 8, 318, 150, 4096, 13, 71},{'Plymouth Fury III', 14, 8, 440, 215, 4312, 8, 70},{'Plymouth Fury III', 15, 8, 318, 150, 4135, 13, 72},{'Plymouth Fury', 18, 6, 225, 95, 3785, 19, 75},{'Plymouth Grand Fury', 16, 8, 318, 150, 4498, 14, 75},{'Plymouth Horizon 4', 34, 4, 105, 63, 2215, 14, 81},{'Plymouth Horizon Miser', 38, 4, 105, 63, 2125, 14, 82},{'Plymouth Horizon TC3', 34, 4, 105, 70, 2150, 14, 79},{'Plymouth Horizon', 34, 4, 105, 70, 2200, 13, 79},{'Plymouth Reliant', 27, 4, 135, 84, 2490, 15, 81},{'Plymouth Reliant', 30, 4, 135, 84, 2385, 12, 81},{'Plymouth Sapporo', 23, 4, 156, 105, 2745, 16, 78},{'Plymouth Satellite (Wagon)', 0, 8, 383, 175, 4166, 10, 70},{'Plymouth Satellite Custom (Wagon)', 14, 8, 318, 150, 4077, 14, 72},{'Plymouth Satellite Custom', 16, 6, 225, 105, 3439, 15, 71},{'Plymouth Satellite Sebring', 18, 6, 225, 105, 3613, 16, 74},{'Plymouth Satellite', 18, 8, 318, 150, 3436, 11, 70},{'Plymouth Valiant Custom', 19, 6, 225, 95, 3264, 16, 75},{'Plymouth Valiant', 18, 6, 225, 105, 3121, 16, 73},{'Plymouth Valiant', 22, 6, 225, 100, 3233, 15, 76},{'Plymouth Volare Custom', 19, 6, 225, 100, 3630, 17, 77},{'Plymouth Volare Premier V8', 13, 8, 318, 150, 3940, 13, 76},{'Plymouth Volare', 20, 6, 225, 100, 3430, 17, 78},{'Pontiac Astro', 23, 4, 140, 78, 2592, 18, 75},{'Pontiac Catalina Brougham', 14, 8, 400, 175, 4464, 11, 71},{'Pontiac Catalina', 14, 8, 400, 175, 4385, 12, 72},{'Pontiac Catalina', 14, 8, 455, 225, 4425, 10, 70},{'Pontiac Catalina', 16, 8, 400, 170, 4668, 11, 75},{'Pontiac Firebird', 19, 6, 250, 100, 3282, 15, 71},{'Pontiac Grand Prix Lj', 16, 8, 400, 180, 4220, 11, 77},{'Pontiac Grand Prix', 16, 8, 400, 230, 4278, 9, 73},{'Pontiac J2000 Se Hatchback', 31, 4, 112, 85, 2575, 16, 82},{'Pontiac Lemans V6', 21, 6, 231, 115, 3245, 15, 79},{'Pontiac Phoenix LJ', 19, 6, 231, 105, 3535, 19, 78},{'Pontiac Phoenix', 27, 4, 151, 90, 2735, 18, 82},{'Pontiac Phoenix', 33, 4, 151, 90, 2556, 13, 79},{'Pontiac Safari (Wagon)', 13, 8, 400, 175, 5140, 12, 71},{'Pontiac Sunbird Coupe', 24, 4, 151, 88, 2740, 16, 77},{'Pontiac Ventura Sj', 18, 6, 250, 110, 3645, 16, 76},{'Renault 12 (Wagon)', 26, 4, 96, 69, 2189, 18, 72},{'Renault 12TL', 27, 4, 101, 83, 2202, 15, 76},{'Renault 18I', 34, 4, 100, 0, 2320, 15, 81},{'Renault 5 Gtl', 36, 4, 79, 58, 1825, 18, 77},{'Renault Lecar Deluxe', 40, 4, 85, 0, 1835, 17, 80},{'Saab 900S', 0, 4, 121, 110, 2800, 15, 81},{'Saab 99E', 25, 4, 104, 95, 2375, 17, 70},{'Saab 99GLE', 21, 4, 121, 115, 2795, 15, 78},{'Saab 99LE', 24, 4, 121, 110, 2660, 14, 73},{'Saab 99LE', 25, 4, 121, 115, 2671, 13, 75},{'Subaru DL', 30, 4, 97, 67, 1985, 16, 77},{'Subaru DL', 33, 4, 97, 67, 2145, 18, 80},{'Subaru', 26, 4, 108, 93, 2391, 15, 74},{'Subaru', 32, 4, 97, 67, 2065, 17, 81},{'Toyota Carina', 20, 4, 97, 88, 2279, 19, 73},{'Toyota Celica GT Liftback', 21, 4, 134, 95, 2515, 14, 78},{'Toyota Celica GT', 32, 4, 144, 96, 2665, 13, 82},{'Toyota Corolla 1200', 31, 4, 71, 65, 1773, 19, 71},{'Toyota Corolla 1200', 32, 4, 71, 65, 1836, 21, 74},{'Toyota Corolla 1600 (Wagon)', 27, 4, 97, 88, 2100, 16, 72},{'Toyota Corolla Liftback', 26, 4, 97, 75, 2265, 18, 77},{'Toyota Corolla Tercel', 38, 4, 89, 60, 1968, 18, 80},{'Toyota Corolla', 28, 4, 97, 75, 2155, 16, 76},{'Toyota Corolla', 29, 4, 97, 75, 2171, 16, 75},{'Toyota Corolla', 32, 4, 108, 75, 2265, 15, 80},{'Toyota Corolla', 32, 4, 108, 75, 2350, 16, 81},{'Toyota Corolla', 34, 4, 108, 70, 2245, 16, 82},{'Toyota Corona Hardtop', 24, 4, 113, 95, 2278, 15, 72},{'Toyota Corona Liftback', 29, 4, 134, 90, 2711, 15, 80},{'Toyota Corona Mark II', 24, 4, 113, 95, 2372, 15, 70},{'Toyota Corona', 24, 4, 134, 96, 2702, 13, 75},{'Toyota Corona', 25, 4, 113, 95, 2228, 14, 71},{'Toyota Corona', 27, 4, 134, 95, 2560, 14, 78},{'Toyota Corona', 31, 4, 76, 52, 1649, 16, 74},{'Toyota Cressida', 25, 6, 168, 116, 2900, 12, 81},{'Toyota Mark II', 19, 6, 156, 108, 2930, 15, 76},{'Toyota Mark II', 20, 6, 156, 122, 2807, 13, 73},{'Toyota Starlet', 39, 4, 79, 58, 1755, 16, 81},{'Toyota Tercel', 37, 4, 89, 62, 2050, 17, 81},{'Toyouta Corona Mark II (Wagon)', 23, 4, 120, 97, 2506, 14, 72},{'Triumph TR7 Coupe', 35, 4, 122, 88, 2500, 15, 80},{'Vokswagen Rabbit', 29, 4, 89, 62, 1845, 15, 80},{'Volkswagen 1131 Deluxe Sedan', 26, 4, 97, 46, 1835, 20, 70},{'Volkswagen 411 (Wagon)', 22, 4, 121, 76, 2511, 18, 72},{'Volkswagen Dasher (Diesel)', 43, 4, 90, 48, 2335, 23, 80},{'Volkswagen Dasher', 25, 4, 90, 71, 2223, 16, 75},{'Volkswagen Dasher', 26, 4, 79, 67, 1963, 15, 74},{'Volkswagen Dasher', 30, 4, 97, 78, 2190, 14, 77},{'Volkswagen Jetta', 33, 4, 105, 74, 2190, 14, 81},{'Volkswagen Model 111', 27, 4, 97, 60, 1834, 19, 71},{'Volkswagen Pickup', 44, 4, 97, 52, 2130, 24, 82},{'Volkswagen Rabbit C (Diesel)', 44, 4, 90, 48, 2085, 21, 80},{'Volkswagen Rabbit Custom Diesel', 43, 4, 90, 48, 1985, 21, 78},{'Volkswagen Rabbit Custom', 29, 4, 97, 78, 1940, 14, 77},{'Volkswagen Rabbit Custom', 31, 4, 89, 71, 1925, 14, 79},{'Volkswagen Rabbit L', 36, 4, 105, 74, 1980, 15, 82},{'Volkswagen Rabbit', 29, 4, 90, 70, 1937, 14, 75},{'Volkswagen Rabbit', 29, 4, 90, 70, 1937, 14, 76},{'Volkswagen Rabbit', 29, 4, 97, 71, 1825, 12, 76},{'Volkswagen Rabbit', 41, 4, 98, 76, 2144, 14, 80},{'Volkswagen Scirocco', 31, 4, 89, 71, 1990, 14, 78},{'Volkswagen Super Beetle 117', 0, 4, 97, 48, 1978, 20, 71},{'Volkswagen Super Beetle', 26, 4, 97, 46, 1950, 21, 73},{'Volkswagen Type 3', 23, 4, 97, 54, 2254, 23, 72},{'Volvo 144EA', 19, 4, 121, 112, 2868, 15, 73},{'Volvo 145E (Wagon)', 18, 4, 121, 112, 2933, 14, 72},{'Volvo 244DL', 22, 4, 121, 98, 2945, 14, 75},{'Volvo 245', 20, 4, 130, 102, 3150, 15, 76},{'Volvo 264GL', 17, 6, 163, 125, 3140, 13, 78},{'Volvo Diesel', 30, 6, 145, 76, 3160, 19, 81}
    ], CarsRecord);

OUTPUT(CarsDataset, NAMED('Cars'));

MultipleValueChartRecord := RECORD
    DATASET(CarsRecord) cars__hidden;
    VARSTRING pc__javascript;
END;

d3Chart := CellFormatter.JavaScript.MultipleValueChart('cars__hidden', 'name');
OUTPUT(DATASET([{CarsDataset, d3Chart.ParallelCoordinates}], MultipleValueChartRecord), NAMED('MultipleValueChart'));

