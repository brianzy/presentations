import re
import string

def remove_punctuation(s):
    table = string.maketrans("","")
    return s.translate(table, string.punctuation)
    
def tokenize(text):
    text = remove_punctuation(text)
    text = text.lower()
    return re.split("\W+", text)

def get_counts(words):
    counts = {}
    for word in words:
        counts[word] = counts.get(word, 0.0) + 1.0
    return counts
    
def merge_two_dicts(x, y):
    '''Given two dicts, merge them into a new dict as a shallow copy.'''
    z = x.copy()
    z.update(y)
    return z
    
# train
with open('men_cleaned.txt') as f:
    men = f.read()
    
with open('women_cleaned.txt') as f:
    women = f.read()
    
men_counts = get_counts(tokenize(men))

women_counts = get_counts(tokenize(women))

vocab = men_counts

for word, count in women_counts.items():
    if word in vocab:
        vocab[word] += count
    else:
        vocab[word] = count

# new example

quote = "I work very hard for a living."

new_quote = get_counts(tokenize(quote))

"""Not Finished yet!!

for w, cnt in new_quote.items():
    if not w in vocab or len(w) <= 3:
        continue

        
    p_word = vocab[w] / sum(vocab.values())
    
    
p_w_given_dino = word_counts["dino"].get(w, 0.0) / sum(word_counts["dino"].values())
    p_w_given_crypto = word_counts["crypto"].get(w, 0.0) / sum(word_counts["crypto"].values())
    # add new probability to our running total: log_prob_<category>. if the probability 
    # is 0 (i.e. the word never appears for the category), then skip it
    if p_w_given_dino > 0:
        log_prob_dino += math.log(cnt * p_w_given_dino / p_word)
    if p_w_given_crypto > 0:
        log_prob_crypto += math.log(cnt * p_w_given_crypto / p_word)

"""
    
