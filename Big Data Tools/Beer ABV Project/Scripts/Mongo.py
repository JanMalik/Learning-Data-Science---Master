################################
### Mallet Oscar & Malik Jan ###
###     06 November 2018     ###
################################

##import csv
##import json
##import pandas
##
##f = pandas.read_csv('C:/Users/Jan Malik/Desktop/Big Data/beer_reviews.csv', sep=",")
###jsonfile = open('beer.json', 'w')
##
##reader = csv.DictReader(f, fieldnames = ("brewery_id", "brewery_name", "review_time", "review_time", "review_overall","review_aroma", "review_appearance", "review_profilename", "beer_style", "review_palate", "review_tate", "beer_abv", "beer_id")
##)
##out = json.dumps( [ row for row in reader ] )
##print("JSON parsed")
##f=open('C:/Users/Jan Malik/Desktop/Big Data/beer.json', 'w')
##f.write(out)
##print("JSON saved")

#!/usr/bin/python

import sys, getopt
import csv
import json

#Get Command Line Arguments
def main(argv):
    input_file = 'C:/Users/Jan Malik/Desktop/Big_Data/beer_reviews.csv'
    output_file = 'C:/Users/Jan Malik/Desktop/Big_Data/parsed.json'
    format = 'C:/Users/Jan Malik/Desktop/Big_Data/beer.json'
    try:
        opts, args = getopt.getopt(argv,"hi:o:f:",["ifile=","ofile=","format="])
    except getopt.GetoptError:
        print('csv_json.py -i <path to inputfile> -o <path to outputfile> -f <dump/pretty>')
        sys.exit(2)
    for opt, arg in opts:
        if opt == '-h':
            print('csv_json.py -i <path to inputfile> -o <path to outputfile> -f <dump/pretty>')
            sys.exit()
        elif opt in ("-i", "--ifile"):
            input_file = arg
        elif opt in ("-o", "--ofile"):
            output_file = arg
        elif opt in ("-f", "--format"):
            format = arg
    read_csv(input_file, output_file, format)

#Read CSV File
def read_csv(file, json_file, format):
    csv_rows = []
    with open(file) as csvfile:
        reader = csv.DictReader(csvfile)
        title = reader.fieldnames
        for row in reader:
            csv_rows.extend([{title[i]:row[title[i]] for i in range(len(title))}])
        write_json(csv_rows, json_file, format)

#Convert csv data into json and write it
def write_json(data, json_file, format):
    with open(json_file, "w") as f:
        if format == "pretty":
            f.write(json.dumps(data, sort_keys=False, indent=4, separators=(',', ': '),encoding="utf-8",ensure_ascii=False))
        else:
            f.write(json.dumps(data))

if __name__ == "__main__":
   main(sys.argv[1:])

