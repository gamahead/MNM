% drawText

% 3/8/04    awi     Wrote it.
% 7/13/04   awi     Added comments section.  
% 9/8/04    awi     Added Try/Catch, cosmetic changes to documentation.
% 1/21/05   awi     Replaced call to GetChar with call to KbWait. 
% 10/6/05	awi		Note here cosmetic changes by dgp between 1/21/05 and 10/6/05	.
% 6/16/14   xxx     JOSH ROSE: Modifying the simple DrawSomeText demo for a
% module that draws an input string to the screen


function [times,keys] = drawText(s)

% Preallocate memory for the times array; This array stores the keypress
% times for each trial
times = zeros(1,length(s));
keys = zeros(1,length(s));

% Suppress Warnings
oldEnableFlag = Screen('Preference', 'SuppressAllWarnings', 1);

% Skip the graphics tests - This should be set back to default for
% experimenting
Screen('Preference', 'SkipSyncTests', 2 );
fontSize = 20;

try
    % Choosing the display with the highest display number is
    % a best guess about where you want the stimulus displayed.
    screens=Screen('Screens');
    screenNumber=max(screens);
    w=Screen('OpenWindow', screenNumber);
    Screen('FillRect', w,[0,0,0,255]);
    Screen('TextFont',w, 'Arial');
    Screen('TextSize',w, fontSize);
    Screen('TextStyle', w, 1);
    
    Screen('TextSize', w, 30);
    Screen('DrawText', w, 'Hit any key to begin.', 100, 300, [255, 100, 0, 255]);
    Screen('Flip',w)
    
    KbWait;
    
    % Get the width and height of the primary screen. If a secondary screen
    % is being used for testing, this will need to be changed (TODO)
    [width,height]=Screen('WindowSize',0);
    
    for i = 1:length(s)
        
        [nx, ny, bbox] = DrawFormattedText(w, s{i}, 'center', 'center',[255, 255, 255, 255]);
        Screen('Flip',w);
        
        [trialResults,press] = PressTime;

        times(i) = trialResults;
        
        if press ~= inf
            keys(i) = KbName(press);
        end  
    end
    
    %Screen('TextFont', w, 'Arial');
    Screen('TextSize', w, 30);
    Screen('DrawText', w, 'Hit any key to exit.', 100, 300, [255, 100, 0, 255]);
    Screen('Flip',w);
    KbWait;
    Screen('CloseAll');
catch
    % This "catch" section executes in case of an error in the "try" section
    % above.  Importantly, it closes the onscreen window if it's open.
    Screen('CloseAll');
    psychrethrow(psychlasterror);
end

% Restore default warning message settings
Screen('Preference','SuppressAllWarnings',oldEnableFlag);
Screen('Preference', 'SkipSyncTests', 0);

return

% This routine is run immediately after the next word is displayed. It
% returns the key that is pressed and the amount of time it takes for the
% key to be pressed
function [pt,key] = PressTime()

pt = inf;
key = inf;
startSecs = GetSecs;

while 1
	[ keyIsDown, timeSecs, keyCode ] = KbCheck;
    
    % Test to see if the word has been up for over a second; Break if yes
    if ((GetSecs - startSecs) > 1.0)
        break;
    end
    
	if keyIsDown && (pt == Inf)
        pt = timeSecs - startSecs;
        key = KbName(keyCode);
        
        % If the user holds down a key, KbCheck will report multiple events.
        % To condense multiple 'keyDown' events into a single event, we wait until all
        % keys have been released.
        while KbCheck; end
	end
end



