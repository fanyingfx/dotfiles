#!/usr/bin/python

import re
import pyperclip

words_fix={
    'W e':'We',
    'Y ou':'You',
    "’ ":"'",
    "’":"'",
    "don' t":"don't",
    "Hask ell":"Haskell",
    "- ":"",
}

def remove_extra_newlines(text):
    # Replace multiple newlines with a single newline
    cleaned_text = re.sub(r'\n', ' ', text)
    cleaned_text = re.sub(r'\s+',' ',cleaned_text)
    for src_word,fixed in words_fix.items():
        cleaned_text = cleaned_text.replace(src_word,fixed)
    return cleaned_text.strip()

# Get text from clipboard
text = pyperclip.paste()

# Clean the text
cleaned_text = remove_extra_newlines(text)

# Copy the cleaned text back to clipboard
pyperclip.copy(cleaned_text)


