#!/usr/bin/python

from iptcinfo3 import IPTCInfo


import sys
import logging
import os
import operator
import pprint

logger = logging.getLogger(__name__)
logger.setLevel(logging.DEBUG)

# create a file handler
handler = logging.FileHandler('hello.log')
handler.setLevel(logging.DEBUG)

# create a logging format
formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
handler.setFormatter(formatter)

# add the handlers to the logger
logger.addHandler(handler)

def sort_dict(dict):
    return sorted(dict.items(), key=operator.itemgetter(1))

def pp(object):
    pp = pprint.PrettyPrinter(indent = 4)
    pp.pprint(object)

def process_file(filename):
    """ Want to return: [filename, caption, [tags]] """

    info = IPTCInfo(filename)
    if len(info.data) < 4: raise Exception(info.error)

    return [filename, info.data["caption/abstract"], info.keywords]

def get_keywords_counts(pictures):
    """ Want to return: list of keywords, times they appear """
    keywords = {}
    logger.debug("There are " + str(len(pictures)) + " pictures.")
    for picture in pictures:
        for word in picture[2]:
            word = word.decode("utf-8")
            if word not in keywords.keys():
                keywords[word] = 1
            else:
                keywords[word] = keywords[word] + 1
    return keywords

def get_keywords(pictures):
    """ Want to return: list of keywords, times they appear """
    keywords = []
    logger.debug("There are " + str(len(pictures)) + " pictures.")
    for picture in pictures:
        for word in picture[2]:
            word = word.decode("utf-8")
            if word not in keywords:
                keywords.append(str(word))
    keywords.sort()
    return keywords


def get_all_pictures(path, pictures=None):
    if pictures == None:
        logger.debug("list is empty")
        pictures = []
    logger.debug("There are " + str(len(pictures)) + " pictures already.")
    path = os.path.abspath(path)
    for file in os.listdir(path):
        pictures.append(process_file(path + "/" + file))
    logger.debug("There are " + str(len(pictures)) + " pictures now.")
    print(str(len(pictures)) + " pictures")
    return pictures

def find_pictures_by_keyword(pictures, keyword):
    matches = []
    for picture in pictures:
        for word in picture[2]:
            if keyword == word:
                matches.append(picture)
                break
    return matches

def display_captions(pictures):
    for index, picture in enumerate(pictures):
        print(str(index) + ": " + picture[1])

def select_from_pictures(pictures):
    display_captions(pictures)
    return raw_input("Select picture number or blank to go back")

#====================================================
# For test, find all files in test directory and create list of all files

#keywords = get_keywords(all_files)

#pp(sort_dict(keywords))
"""
pictures = None
while True:
    inp = raw_input("1: Read Files into system\n2: Get keywords\n3: Find files in system with keyword\n4: Show keywords sorted\n5: quit\n")
    if inp == "1": # Read Files into System
        inp = raw_input("Which directory?\n")
        #Box 1
        pictures = get_all_pictures(inp, pictures)
        logger.debug(str(len(pictures)) + " pictures found")
    elif inp == "2": # Get Keywords
        logger.debug(str(len(pictures)) + " pictures to get keywords from")
        keywords = get_keywords(pictures)
    elif inp == "3": # Find files in system with keyword
        inp = raw_input("Keyword?\n")
        matches = find_pictures_by_keyword(pictures, inp)
        display_captions(matches)
    elif inp == "5":
        break
    elif inp == "4":
        pp(sort_dict(keywords))
"""