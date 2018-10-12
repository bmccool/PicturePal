from picture_utils import *

print ("hello")

pictures = None
pictures = get_all_pictures("Pictures")
keywords = get_keywords(pictures)
keywords = sort_dict(keywords)
pp(pictures)