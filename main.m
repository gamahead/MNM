%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is the main script that is used for starting the experiment
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

inpt = inputdlg('Subject ID: ','MNM');
subject = inpt{1};

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

% Keynames: z = 90; ?/ = 191; Unicode: z = 90, ? = 63

% Enable unified mode of KbName, so KbName accepts identical key names on
% all operating systems. EDIT: I don't really know why this is necessary,
% but I'm going to leave it here

 KbName('UnifyKeyNames');

[times,keys] = drawText(testWords);

% Write out the results

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TODO: Find out what Linh wants the directory 
% structure to look like and what she wants in the output - they probably 
% already have a scheme in their lab 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

c = {'Times' 'Keys'; times keys}; 

dataNum = 0;
idString = [subject,'-',date,'.csv'];

% Check to see if there is already a data file with the same name and
% change accordingly until there is not
while exist(['Data/',idString],'file') == 2
    idString = [subject,num2str(dataNum),'-',date,'.csv'];
    dataNum = dataNum + 1;
end

fid = fopen(['Data/',idString],'w');

fprintf(fid,'%s, %s\n',c{1,:});

% Handle and output data

for i = 1:length(times)
    
    % Start by changing the encoding for the question mark - PsychToolBox
    % thinks /? = 191, but the Unicode encoding is 63
    if keys(i) == 191
        keys(i) = 63;
    end
    
    % Output time and key pressed
    fprintf(fid,'%f,',times(i));
    fprintf(fid,'%s\n',keys(i));
    
end

fclose(fid);
