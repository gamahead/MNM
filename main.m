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

testWords = {'test1','test2','test3','test4'};

% z = 90; / = 191z

% Enable unified mode of KbName, so KbName accepts identical key names on
% all operating systems:

% KbName('UnifyKeyNames');

[times,keys] = drawText(testWords);

c = {'Times' 'Keys'; times keys}; 
fid = fopen('junk.csv','w');

fprintf(fid,'%s, %s\n',c{1,:});

for i = 1:length(times)
    fprintf(fid,'%f,',times(i));
    fprintf(fid,'%f\n',keys(i));
end


fclose(fid);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TODO: Convert the encodings in the keys vector to something that doesn't
% have an upside down question mark in the output. Also, fuck varying
% character encoding schemes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

