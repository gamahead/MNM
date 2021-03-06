 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is the main script that is used for starting the experiment
%
% TODO: Fix Data folder construction; Make sure text is appropriately
% aligned; 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Get Subject's ID
prompt = {'Subject ID: ','Condition: '};
dlg_title = 'MNM';
num_lines = 1;
def = {'',''};

condition = '0';
attempts = 0;
inpt = {'',''};
while ~(strcmp(condition,num2str(1)) || strcmp(condition,num2str(2)))
    if attempts > 0
        inpt = inputdlg(prompt,dlg_title,num_lines,{inpt{1},'Please enter 1 or 2'});
        condition = inpt{2};
        attempts = attempts + 1;
    else
        inpt = inputdlg(prompt,dlg_title,num_lines,def);
        attempts = attempts + 1;
        condition = inpt{2};
    end
end

subject = inpt{1};
condition = inpt{2};

HideCursor;

% Make sure there is a 'Data' folder
if exist('Data','file') ~= 7
    system('mkdir Data');
end

c = {'Subject' 'Condition' 'Trial' 'Stimword' 'Response' 'Category' 'RT'}; 

dataNum = 0;
idString = [subject,'-',date,'.csv'];


% Check to see if there is already a data file with the same name and
% change accordingly until there is not
while exist(['Data/',idString],'file') == 2
    idString = [subject,'-',date,'_',num2str(dataNum),'.csv'];
    dataNum = dataNum + 1;
end

fid = fopen(['Data/',idString],'w');

for i = 1:length(c)
    fprintf(fid,'%s,',c{i});
end
fprintf(fid,'\n');


% Setting up the screen %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Suppress Warnings
oldEnableFlag = Screen('Preference', 'SuppressAllWarnings', 1);

% Skip the graphics tests - This should be set back to default for
% experimenting
Screen('Preference', 'SkipSyncTests', 2 );

% Choosing the display with the highest display number is
% a best guess about where you want the stimulus displayed.
screens=Screen('Screens');
screenNumber=max(screens);
w=Screen('OpenWindow', screenNumber);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Read in the list of words from the word list
rawWords = textread('wordlist.txt','%s');

% Randomize the list
indices1 = randperm(length(rawWords));
indices2 = randperm(length(rawWords));

for i = 1:size(rawWords)
    randWords1(i) = rawWords(indices1(i));
    randWords2(i) = rawWords(indices2(i));
end

stims = [randWords1,randWords2];

% These are the words used for the preliminary task; just change them to 
% make them whatever you want them to be 
testWords = {'talkative','helpful','quiet','romantic'};

% Encodings for Keynames: z = 90; ?/ = 191; Unicode: z = 90, ? = 63

% Enable unified mode of KbName, so KbName accepts identical key names on
% all operating systems. EDIT: I don't really know why this is necessary,
% but I'm going to leave it here

KbName('UnifyKeyNames');
 
% Run the testWords in the prelim - Passing 1 runs the prelim
[times,keys] = runWords(testWords,1,w,fid,subject,condition);

% Run the real words in the main experiment - Passing 0 runs the experiment
[times,keys] = runWords(stims,0,w,fid,subject,condition);

fclose(fid);

% Restoring Screen Defaults %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Restore default warning message settings
Screen('Preference','SuppressAllWarnings',oldEnableFlag);
Screen('Preference', 'SkipSyncTests', 0);