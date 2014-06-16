% Read in the list of words from the word list
rawWords = textread('wordlist.txt','%s');

% Randomize the list

indices1 = randperm(length(rawWords));
indices2 = randperm(length(rawWords));

for i = 1:size(rawWords)
    randWords1(i) = rawWords(indices1(i));
    randWords2(i) = rawWords(indices2(i));
end

% Run the experiment



