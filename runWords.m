% drawText

% 3/8/04    awi     Wrote it.
% 7/13/04   awi     Added comments section.  
% 9/8/04    awi     Added Try/Catch, cosmetic changes to documentation.
% 1/21/05   awi     Replaced call to GetChar with call to KbWait. 
% 10/6/05	awi		Note here cosmetic changes by dgp between 1/21/05 and 10/6/05	.
% 6/16/14   xxx     JOSH ROSE: Modifying the simple DrawSomeText demo for a
% module that draws an input string to the screen

% Args: runWords([list of words],[1 if prelim; 0 if experiment],[screen
% number]);

function [times,keys] = runWords(s,prelim,w)

% Preallocate memory for the times array; This array stores the keypress
% times for each trial
times = zeros(1,length(s));
keys = zeros(1,length(s));

fontSize = 20;

try
    
    Screen('FillRect', w,[0,0,0,255]);
    Screen('TextFont',w, 'Arial');
    Screen('TextSize',w, fontSize);
    Screen('TextStyle', w, 1);
    
    Screen('TextSize', w, 30);
    
    if prelim == 1
        Screen('TextSize', w, 10);

        text = ['Before the experiment begins, you will complete 4\n'...
            ,'training trials to get yourself acclimated to the task\n'...
            ,'Press the z key if the characteristic displayed in the center\n'...
            ,'of the screen is representative of you, and press the ? key if\n'...
            ,'it does not represent you\n\n'...
            ,'Press any key to continue'];
    else
        text = ['Press any key to continue to the experiment'];
    end
    
    Screen('TextSize', w, 30);

    [nx, ny, bbox] = DrawFormattedText(w, text,'center',50,[255, 255, 255, 255]);
    % Screen('DrawText', w, text, 100, 300, [255, 100, 0, 255]);
    Screen('Flip',w)
    
    KbWait;
    
    % Get the width and height of the primary screen. If a secondary screen
    % is being used for testing, this will need to be changed (TODO)
    [width,height]=Screen('WindowSize',0);
    
    for i = 1:length(s)
        
        pause(1);

        [nx, ny, bbox] = DrawFormattedText(w, 'Me', 'left',50,[255, 255, 255, 255]);
        [nx, ny, bbox] = DrawFormattedText(w, 'Not Me', 'right',50,[255, 255, 255, 255]);
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
    
    if prelim == 0
        Screen('DrawText', w, 'Hit any key to exit.', 100, 300, [255, 100, 0, 255]);
    else
        Screen('DrawText', w, 'Training session over - Press any key to continue', 100, 300, [255, 100, 0, 255]);
    end
    Screen('Flip',w);
    pause(1);
    KbWait;
    pause(1);
    
    if prelim == 0
        Screen('CloseAll');
    end
    
catch
    % This "catch" section executes in case of an error in the "try" section
    % above.  Importantly, it closes the onscreen window if it's open.
    Screen('CloseAll');
    psychrethrow(psychlasterror);
end

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
    
    % This pause is meant to prevent this while loop from eating up the
    % processor. 
    pause(.001)
    
    % Test to see if the word has been up for over a second; Break if yes
%     if ((GetSecs - startSecs) > 1.0)
%         break;
%     end
    
	if keyIsDown && (pt == Inf)
        pt = timeSecs - startSecs;
        key = KbName(keyCode);
        while KbCheck; end
        
        break;
        % If the user holds down a key, KbCheck will report multiple events.
        % To condense multiple 'keyDown' events into a single event, we wait until all
        % keys have been released.
	end
end



