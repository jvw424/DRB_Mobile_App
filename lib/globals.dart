const String appwriteId = "648509fdd710dc1e8297";
const String appwriteUrl = "https://cloud.appwrite.io/v1";

const String appwriteDatabaseId = "648551a82c1b62cd5468";
const String collectionSubmissions = "648551be6664582fb684";
const String collectionLoctions = "6487eceb42b72c141cb9";

const List locations = [
  {
    'name': "Lotte",
    'number': 1003,
    //1805 Industrial St, Los Angeles, CA 90021
    'zip': 90021,
    'city': 'Los Angeles',
    'street': 'Industrial Street',
    'address': 1805,
    'state': "CA",
    'lat': 34.03619,
    'long': -118.23393
  },
  {
    'name': "Crazy Gideon's",
    'number': 1004,
    //830 Traction Ave, Los Angeles, CA 90013
    'zip': 90013,
    'city': 'Los Angeles',
    'street': 'Traction Ave',
    'address': 830,
    'state': "CA",
    'lat': 34.04455,
    'long': -118.23532
  },
  {
    'name': "Villians Tavern",
    'number': 1005,
    //1356 Palmetto St, Los Angeles, CA 90013
    'zip': 90013,
    'city': 'Los Angeles',
    'street': 'Palmetto St',
    'address': 1356,
    'state': "CA",
    'lat': 34.04017,
    'long': -118.23096
  },
  {
    'name': "Garment",
    'number': 1010,
    //1219 S Los Angeles St, Los Angeles, CA 90015
    'zip': 90015,
    'city': 'Los Angeles',
    'street': 'S Los Angeles St',
    'address': 1219,
    'state': "CA",
    'lat': 34.03665,
    'long': -118.25937
  },
  {
    'name': "Burger King",
    'number': 1012,
    //833 S Central Ave, Los Angeles, CA 90021
    'zip': 90021,
    'city': 'Los Angeles',
    'street': 'S Central Ave',
    'address': 833,
    'state': "CA",
    'lat': 34.03279,
    'long': -118.24421
  },
  {
    'name': "Elote Blanco",
    'number': 1014,
    //925 E 9th St, Los Angeles, CA 90021
    'zip': 90021,
    'city': 'Los Angeles',
    'street': 'E 9th St',
    'address': 925,
    'state': "CA",
    'lat': 34.03498,
    'long': -118.24747
  },
  {
    'name': "Corner Lot",
    'number': 1015,
    //1251 E Olympic Blvd, Los Angeles, CA 90021
    'zip': 90021,
    'city': 'Los Angeles',
    'street': 'E Olympic Blvd',
    'address': 1251,
    'state': "CA",
    'lat': 34.03264,
    'long': -118.24448
  },
  {
    'name': "School Lot",
    'number': 1020,
    //1000 E Olympic Blvd, Los Angeles, CA 90021
    'zip': 90021,
    'city': 'Los Angeles',
    'street': 'E Olympic Blvd',
    'address': 1000,
    'state': "CA",
    'lat': 34.03403,
    'long': -118.24743
  },
  {
    'name': "Pasadena Church",
    'number': 1022,
    //200 N Euclid Ave, Pasadena, CA 91101
    'zip': 91101,
    'city': 'Pasadena',
    'street': 'N Euclid Ave',
    'address': 200,
    'state': "CA",
    'lat': 34.149,
    'long': -118.14244
  },
  {
    'name': "Beacon",
    'number': 1023,
    //360 S Alameda St, Los Angeles, CA 90013
    'zip': 90013,
    'city': 'Los Angeles',
    'street': 'S Alameda St',
    'address': 360,
    'state': "CA",
    'lat': 34.04362,
    'long': -118.23786
  },
  {
    'name': "Mariachi Plaza",
    'number': 1028,
    //1717 East Mariachi Plaza De, Los Angeles, CA 90033
    'zip': 90033,
    'city': 'Los Angeles',
    'street': 'East Mariachi Plaza De',
    'address': 1717,
    'state': "CA",
    'lat': 34.04749,
    'long': -118.21921
  },
  {
    'name': "Saint Xavier",
    'number': 1032,
    //222 S Hewitt St, Los Angeles, CA 90012
    'zip': 90012,
    'city': 'Los Angeles',
    'street': 'S Hewitt St',
    'address': 222,
    'state': "CA",
    'lat': 34.04663,
    'long': -118.23589
  },
  {
    'name': "McDonald's",
    'number': 1033,
    //201 W Washington Blvd, Los Angeles, CA 90015
    'zip': 90015,
    'city': 'Los Angeles',
    'street': 'W Washington Blvd',
    'address': 201,
    'state': "CA",
    'lat': 34.0324,
    'long': -118.26696
  },
  {
    'name': "Luna",
    'number': 1037,
    //713 E 3rd St, Los Angeles, CA 90013
    'zip': 90013,
    'city': 'Los Angeles',
    'street': 'E 3rd St',
    'address': 713,
    'state': "CA",
    'lat': 34.04584,
    'long': -118.23746
  },
  {
    'name': "Britt",
    'number': 1039,
    //1934 E 7th St, Los Angeles, CA 90021
    'zip': 90021,
    'city': 'Los Angeles',
    'street': 'E 7th St',
    'address': 1934,
    'state': "CA",
    'lat': 34.03457,
    'long': -118.23279
  },
  {
    'name': "Violet",
    'number': 1041,
    //905 S Santa Fe Ave, Los Angeles, CA 90021
    'zip': 90021,
    'city': 'Los Angeles',
    'street': 'S Santa Fe Ave',
    'address': 905,
    'state': "CA",
    'lat': 34.03228,
    'long': -118.23034
  },
  {
    'name': "Diesel",
    'number': 1042,
    //826 Mateo St, Los Angeles, CA 90021
    'zip': 90021,
    'city': 'Los Angeles',
    'street': 'Mateo',
    'address': 826,
    'state': "CA",
    'lat': 34.03275,
    'long': -118.23176
  },
  {
    'name': "Officine Brera",
    'number': 1043,
    //1337 E 6th St, Los Angeles, CA 90021
    'zip': 90021,
    'city': 'Los Angeles',
    'street': 'E 6th St',
    'address': 1337,
    'state': "CA",
    'lat': 34.03846,
    'long': -118.2345
  },
  {
    'name': "Factory Kitchen",
    'number': 1044,
    //1256 Factory Pl, Los Angeles, CA 90013
    'zip': 90013,
    'city': 'Los Angeles',
    'street': 'Factory Pl',
    'address': 1256,
    'state': "CA",
    'lat': 34.03902,
    'long': -118.23667
  },
  {
    'name': "Garey",
    'number': 1049,
    //905 E 2nd St, Los Angeles, CA 90012
    'zip': 90012,
    'city': 'Los Angeles',
    'street': 'E 2nd St',
    'address': 905,
    'state': "CA",
    'lat': 34.04774,
    'long': -118.23498
  },
  {
    'name': "Rams",
    'number': 1051,
    //469 W 40th Pl, Los Angeles, CA 90037
    'zip': 90037,
    'city': 'Los Angeles',
    'street': 'W 40th Pl',
    'address': 469,
    'state': "CA",
    'lat': 34.01035,
    'long': -118.28233
  },
  {
    'name': "Dumpling",
    'number': 1056,
    //2005 E 7th St, Los Angeles, CA 90021
    'zip': 90021,
    'city': 'Los Angeles',
    'street': 'E 7th St',
    'address': 2005,
    'state': "CA",
    'lat': 34.03473,
    'long': -118.23211
  },
  {
    'name': "Art House",
    'number': 1059,
    //1250 S Santa Fe Ave, Los Angeles, CA 90021
    'zip': 90021,
    'city': 'Los Angeles',
    'street': 'S Santa Fe Ave',
    'address': 1250,
    'state': "CA",
    'lat': 34.02866,
    'long': -118.22983
  },
  {
    'name': "Aliso",
    'number': 1060,
    //950 E 3rd St, Los Angeles, CA 90013
    'zip': 90013,
    'city': 'Los Angeles',
    'street': 'E 3rd St',
    'address': 950,
    'state': "CA",
    'lat': 34.0458,
    'long': -118.23406
  },
  {
    'name': "Sun",
    'number': 1062,
    //114 W 14th St, Los Angeles, CA 90015
    'zip': 90015,
    'city': 'Los Angeles',
    'street': 'W 14th St',
    'address': 114,
    'state': "CA",
    'lat': 34.03516,
    'long': -118.26203
  },
  {
    'name': "Oak",
    'number': 1065,
    //1439 Oak St, Los Angeles, CA 90015
    'zip': 90015,
    'city': 'Los Angeles',
    'street': 'Oak St',
    'address': 1439,
    'state': "CA",
    'lat': 34.04053,
    'long': -118.27504
  },
  {
    'name': "LAMM",
    'number': 1066,
    //208 E 6th St, Los Angeles, CA 90014
    'zip': 90014,
    'city': 'Los Angeles',
    'street': 'E 6th St',
    'address': 208,
    'state': "CA",
    'lat': 34.04354,
    'long': -118.24916
  },
  {
    'name': "Budokan",
    'number': 1067,
    //249 S Los Angeles St, Los Angeles, CA 90012
    'zip': 90012,
    'city': 'Los Angeles',
    'street': 'S Los Angeles St',
    'address': 249,
    'state': "CA",
    'lat': 34.04912,
    'long': -118.2444
  },
  {
    'name': "Oriel",
    'number': 1068,
    //1135 N Alameda St, Los Angeles, CA 90012
    'zip': 90012,
    'city': 'Los Angeles',
    'street': 'N Alameda St',
    'address': 1135,
    'state': "CA",
    'lat': 34.06268,
    'long': -118.23634
  },
  {
    'name': "Zenshuji",
    'number': 1069,
    //612 1st St, Los Angeles, CA 90012
    'zip': 90012,
    'city': 'Los Angeles',
    'street': '1st St',
    'address': 612,
    'state': "CA",
    'lat': 34.0486,
    'long': -118.23661
  },
  {
    'name': "Crocker",
    'number': 1070,
    //414 Crocker St, Los Angeles, CA 90013
    'zip': 90013,
    'city': 'Los Angeles',
    'street': 'Crocker St',
    'address': 414,
    'state': "CA",
    'lat': 34.04421,
    'long': -118.2416
  },
  {
    'name': "Produce",
    'number': 1071,
    //640 S Santa Fe Ave, Los Angeles, CA 90021
    'zip': 90021,
    'city': 'Los Angeles',
    'street': 'S Santa Fe Ave',
    'address': 640,
    'state': "CA",
    'lat': 34.03703,
    'long': -118.22991
  },
  {
    'name': "Dynasty Garage",
    'number': 1072,
    //821 N Spring St, Los Angeles, CA 90012
    'zip': 90012,
    'city': 'Los Angeles',
    'street': 'N Spring St',
    'address': 821,
    'state': "CA",
    'lat': 34.06264,
    'long': -118.23703
  },
  {
    'name': "Linear",
    'number': 1073,
    //660 Mateo St, Los Angeles, CA 90021
    'zip': 90021,
    'city': 'Los Angeles',
    'street': 'Mateo St',
    'address': 660,
    'state': "CA",
    'lat': 34.03599,
    'long': -118.23213
  },
  {
    'name': "Vinz",
    'number': 1074,
    //950 S Fairfax Ave, Los Angeles, CA 90036
    'zip': 90036,
    'city': 'Los Angeles',
    'street': 'S Fairfax Ave',
    'address': 950,
    'state': "CA",
    'lat': 34.05876,
    'long': -118.36322
  },
  {
    'name': "Anonymous",
    'number': 1075,
    //8501 Washington Blvd, Culver City, CA 90232
    'zip': 90232,
    'city': 'Culver City',
    'street': 'Washington Blvd',
    'address': 8501,
    'state': "CA",
    'lat': 34.03134,
    'long': -118.37903
  },
  {
    'name': "Linrose",
    'number': 2002,
    //320 Lincoln Blvd, Venice, CA 90291
    'zip': 90291,
    'city': 'Venice',
    'street': 'Lincoln Blvd',
    'address': 320,
    'state': "CA",
    'lat': 34.00104,
    'long': -118.46681
  },
  {
    'name': "Marine",
    'number': 2004,
    //3016 N Main St, Los Angeles, CA 90031
    'zip': 90031,
    'city': 'Los Angeles',
    'street': 'N Main St',
    'address': 3016,
    'state': "CA",
    'lat': 34.06586,
    'long': -118.20952
  },
  {
    'name': "Office",
    'number': 1000,
    //720 Gladys Ave, Los Angeles, CA 90021
    'zip': 90021,
    'city': 'Los Angeles',
    'street': 'Gladys Ave',
    'address': 720,
    'state': "CA",
    'lat': 34.03806,
    'long': -118.24425
  },
];
