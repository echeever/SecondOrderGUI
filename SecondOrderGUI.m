function varargout = SecondOrderGUI(varargin)
% SECONDORDERGUI MATLAB code for SecondOrderGUI.fig
%      SECONDORDERGUI, by itself, creates a new SECONDORDERGUI or raises the existing
%      singleton*.
%
%      H = SECONDORDERGUI returns the handle to a new SECONDORDERGUI or the handle to
%      the existing singleton*.
%
%      SECONDORDERGUI('CALLBACK',hObject,~,handles,...) calls the local
%      function named CALLBACK in SECONDORDERGUI.M with the given input arguments.
%
%      SECONDORDERGUI('Property','Value',...) creates a new SECONDORDERGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SecondOrderGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SecondOrderGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SecondOrderGUI

% Last Modified by GUIDE v2.5 08-Mar-2015 12:03:00

%#ok<*DEFNU>

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @SecondOrderGUI_OpeningFcn, ...
    'gui_OutputFcn',  @SecondOrderGUI_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before SecondOrderGUI is made visible.
function SecondOrderGUI_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% ~  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SecondOrderGUI (see VARARGIN)

% Choose default command line output for SecondOrderGUI
handles.output = hObject;
wbh=waitbar(0,'Initializing');

axes(handles.axTfDisplay);  axis('off');

axes(handles.axZeta);  axis('off');  % Display zeta in upper left panel
text(0.5,0.5,'$\zeta$',...
    'Interpreter','Latex','FontSize',14,'HorizontalAlignment','center');

axes(handles.axOmega);  axis('off');
text(0.5,0.5,'$\omega_0^2$',...
    'Interpreter','Latex','FontSize',14,'HorizontalAlignment','center');
waitbar(0.1,wbh);

DisplayFunction(handles, 'Lowpass', ...
    '\frac{\omega_0^2}{s^2+2\zeta\omega_0+\omega_0^2}');
ChooseFunction(handles.ChooseLP,handles);

handles.uiPanelStep.Title = ...
    'Step Response (Choose ''Response'' in menu)';
handles.uiPanelImpulseTitle = ...
    'Impulse Response (Choose ''Response'' in menu)';
handles.uiPanelBode.Title = ...
    'Bode Response (Choose ''Response'' in menu)';

%handles.ChooseLP.Checked='on';
handles.menuAllowMult.Checked='on';

handles.menuPlotStep.Checked='off';
handles.menuPlotBode.Checked='off';
handles.menuPlotImpulse.Checked='off';

handles.menuSgrid.Checked='off';
handles.menuGrids.Checked='off';

handles.axStep.Visible='off';
cla(handles.axStep);        % Erase all graphs
handles.axImpulse.Visible='off';
cla(handles.axImpulse);     % Erase all graphs
handles.axBodeMag.Visible='off';
cla(handles.axBodeMag);     % Erase all graphs
handles.axBodePhase.Visible='off';
cla(handles.axBodePhase);     % Erase all graphs

% load all the zeta checkboxes into an array (also omega)
handles.zcb = [handles.cbz1 handles.cbz2 handles.cbz3 handles.cbz4 ...
    handles.cbz5 handles.cbz6 handles.cbz7 handles.cbz8 handles.cbz9 ...
    handles.cbzOther];
handles.wcb = [handles.cbw1 handles.cbw2 handles.cbw3 handles.cbw4 ...
    handles.cbwOther];

handles.grey=0.8*[1 1 1];
handles.uipanelInput.BackgroundColor=handles.grey;

% Hue order array for zeta.
% handles.zHord=[1 0 0; 0 1 0; 0 1 1; 0.9 0.3 1; 1 0.7 0; ...
%   0 0 1; 0.7 0.7 0.7; 0.9 0.9 0; 1 0 1;];
handles.zHord=[0 1.4/9 4.5/9 6/9 8/9 1/9 3/9 5/9 7/9 0];

% c=handles.zHord
for i=1:length(handles.zcb),
    handles.zcb(i).ForegroundColor=hsv2rgb([handles.zHord(i) 1 1]);
    handles.zcb(i).BackgroundColor=handles.grey;
    handles.zcb(i).FontWeight='bold';
end
handles.cbzOther.BackgroundColor=handles.grey;

% Saturation, value and width order array for omega
handles.wSord = [1 0.8 0.6 0.4 0.5];
handles.wVord = [1 0.9 0.8 0.7 0.6];
handles.wWidth = [0.5 1.25 2 3 1];
for j=1:length(handles.wcb),
    handles.wcb(j).ForegroundColor=hsv2rgb([0.833 handles.wSord(j) handles.wVord(j)]);
    %handles.wcb(j).ForegroundColor=hsv2rgb([0 0  handles.wSord(i)]);
    handles.wcb(j).BackgroundColor=handles.grey;
    handles.wcb(j).FontWeight='bold';
end
handles.cbwOther.BackgroundColor=handles.grey;

clearZetaBoxes(handles);           % Clear zeta and omega check boxes
handles.cbzother.Value = 0;
handles.editzOther.String = 'Other';
clearOmegaBoxes(handles);
handles.cbwOther.Value = 0;
handles.editwOther.String = 'Other';


handles.zcb(4).Value = 1;          % Default (Starting Value) of zeta
handles.LastZeta = handles.zcb(4); % Save last selected checkbox.
handles.wcb(2).Value = 1;          % Also for omega
handles.LastOmega = handles.wcb(2);

handles.figure1.ToolBar='figure';  % Turn on toolbar so axes can zoom.
handles.figure1.MenuBar='none';    % Turn off menubar.



% Update handles structure
guidata(hObject, handles);



figure(wbh);
waitbar(0.2,wbh);
H = tf(1,[1 1]);                   % Run tf for the first time.
waitbar(0.4,wbh);
x = step(H);                       %#ok<NASGU> % Run step for the first time;
waitbar(0.6,wbh);
x = impulse(H);                    %#ok<NASGU> % Run impulse for the first time;
waitbar(0.8,wbh);
x = bode(H);                       %#ok<NASGU> % Run bode for the first time;
close(wbh)

makePlots(handles);
% UIWAIT makes SecondOrderGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SecondOrderGUI_OutputFcn(~, ~, handles)
varargout{1} = handles.output;



function ChooseFunc_Callback(~, ~, ~)

% --------------------------------------------------------------------
function ChooseLP_Callback(hObject, ~, handles)
ChooseFunction(hObject, handles);
DisplayFunction(handles, 'Lowpass', ...
    '\frac{\omega_0^2}{s^2+2\zeta\omega_0+\omega_0^2}');
makePlots(handles);

% --------------------------------------------------------------------
function ChooseHP_Callback(hObject, ~, handles)
ChooseFunction(hObject, handles);
DisplayFunction(handles, 'Highpass', ...
    '\frac{s^2}{s^2+2\zeta\omega_0+\omega_0^2}');
makePlots(handles);

% --------------------------------------------------------------------
function ChooseBP_Callback(hObject, ~, handles)
ChooseFunction(hObject, handles);
DisplayFunction(handles, 'Bandpass', ...
    '\frac{2\zeta\omega_0}{s^2+2\zeta\omega_0+\omega_0^2}');
makePlots(handles);

% --------------------------------------------------------------------
function ChooseBR_Callback(hObject, ~, handles)
ChooseFunction(hObject, handles);
DisplayFunction(handles, 'Notch', ...
    '\frac{s^2+\omega_0^2}{s^2+2\zeta\omega_0+\omega_0^2}');
makePlots(handles);

function ChooseFunction(hObject, handles)
% When a function is selected, deselect all other functions, update plots.
handles.ChooseLP.Checked = 'off';
handles.ChooseHP.Checked = 'off';
handles.ChooseBP.Checked = 'off';
handles.ChooseBR.Checked = 'off';
if isempty(hObject)   % if no first argument
    handles.ChooseLP.Checked = 'off';
else
    hObject.Checked = 'on';
end

function DisplayFunction(handles, ftype, s)
% Display string in figure.
axes(handles.axTfDisplay);  cla;
text(0.5,0.5,['$ H_{' ftype '}(s) = ' s '$'],...
    'Interpreter','Latex','FontSize',14,'HorizontalAlignment','center');

function ChooseHelp_Callback(~, ~, ~)

function ChooseUsing_Callback(~, ~, ~)
web('http://www.swarthmore.edu/NatSci/echeeve1/Ref/2ndOrderGUI/',...
    '-browser');

function cbz1_Callback(hObject, ~, handles)
selectZeta(hObject,handles);

function cbz2_Callback(hObject, ~, handles)
selectZeta(hObject,handles);

function cbz3_Callback(hObject, ~, handles)
selectZeta(hObject,handles);

function cbz4_Callback(hObject, ~, handles)
selectZeta(hObject,handles);

function cbz5_Callback(hObject, ~, handles)
selectZeta(hObject,handles);

function cbz6_Callback(hObject, ~, handles)
selectZeta(hObject,handles);

function cbz7_Callback(hObject, ~, handles)
selectZeta(hObject,handles);

function cbz8_Callback(hObject, ~, handles)
selectZeta(hObject,handles);

function cbz9_Callback(hObject, ~, handles)
selectZeta(hObject,handles);

function cbzOther_Callback(hObject, ~, handles)
selectZeta(hObject,handles);
handles.editzOther.String = hObject.String;

function editzOther_Callback(hObject, ~, handles)
myNum = str2double(hObject.String);
while isnan(myNum)
    myNum = str2double(inputdlg('Enter a valid number:', 'Reenter Number:'));
end
handles.cbzOther.String = num2str(myNum);
hObject.String = num2str(myNum);
makePlots(handles);

function editzOther_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function cbw1_Callback(hObject, ~, handles)
selectOmega(hObject,handles);

function cbw2_Callback(hObject, ~, handles)
selectOmega(hObject,handles);

function cbw3_Callback(hObject, ~, handles)
selectOmega(hObject,handles);

function cbw4_Callback(hObject, ~, handles)
selectOmega(hObject,handles);

function cbw5_Callback(hObject, ~, handles)
selectOmega(hObject,handles);

function cbwOther_Callback(hObject, ~, handles)
selectOmega(hObject,handles);
handles.editwOther.String = hObject.String;

function editwOther_Callback(hObject, ~, handles)
handles.cbwOther.String = hObject.String;
myNum = str2double(hObject.String);
while isnan(myNum)
    myNum = str2double(inputdlg('Enter a valid number:', 'Reenter Number:'));
end
handles.cbwOther.String = num2str(myNum);
hObject.String = num2str(myNum);
makePlots(handles);

function editwOther_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function clearZetaBoxes(handles)
for i = 1:length(handles.zcb)
    handles.zcb(i).Value = 0;
end

function clearOmegaBoxes(handles)
for i = 1:length(handles.wcb)
    handles.wcb(i).Value = 0;
end

function selectZeta(hObject, handles)
if isequal(handles.menuAllowMult.Checked,'off'),
    clearZetaBoxes(handles);
    hObject.Value=1;
end
if hObject.Value == 1       % If unchecked
    handles.LastZeta=hObject;
end
guidata(hObject, handles);  % Updata handles.
makePlots(handles);

function selectOmega(hObject, handles)
if isequal(handles.menuAllowMult.Checked,'off'),
    clearOmegaBoxes(handles);
    hObject.Value=1;
end
if hObject.Value == 1       % If unchecked
    handles.LastOmega = hObject; % Save last selected checkbox.
end
guidata(hObject, handles);  % Updata handles.
makePlots(handles);


% --------------------------------------------------------------------
function menuOptions_Callback(~, ~, ~)

% --------------------------------------------------------------------
function menuAllowMult_Callback(hObject, ~, handles)
if isequal(hObject.Checked,'on'),
    hObject.Checked = 'off';
    menuClear_Callback(hObject,[], handles);
    makePlots(handles);
else
    hObject.Checked = 'on';
end


% --------------------------------------------------------------------
function menuClear_Callback(hObject, ~, handles)
clearZetaBoxes(handles);
handles.cbzOther.Value = 0;
handles.LastZeta.Value = 1;

clearOmegaBoxes(handles);
handles.cbwOther.Value = 0;
handles.LastOmega.Value = 1;

guidata(hObject, handles);  % Updata handles.
makePlots(handles);

% --------------------------------------------------------------------
function menuGrids_Callback(hObject, ~, handles)
if isequal(hObject.Checked,'on'),
    hObject.Checked = 'off';
else
    hObject.Checked = 'on';
end
makePlots(handles);


% --------------------------------------------------------------------
function menuSgrid_Callback(hObject, ~, handles)
if isequal(hObject.Checked,'on'),
    hObject.Checked = 'off';
else
    hObject.Checked = 'on';
end
makePlots(handles);


% --------------------------------------------------------------------
function menuResponse_Callback(~, ~, ~)
% hObject    handle to menuResponse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menuPlotStep_Callback(hObject, ~, handles)
if isequal(hObject.Checked,'on'),
    hObject.Checked = 'off';
    handles.axStep.Visible = 'off';
    cla(handles.axStep);
    handles.uiPanelStep.Title = ...
        'Step Response (Choose ''Response'' in menu)';
else
    hObject.Checked = 'on';
    plotStep(handles);
    handles.axStep.Visible = 'on';
    handles.uiPanelStep.Title = 'Step Response';
end


% --------------------------------------------------------------------
function menuPlotBode_Callback(hObject, ~, handles)
if isequal(hObject.Checked,'on'),
    hObject.Checked = 'off';
    handles.axBodeMag.Visible = 'off';
    cla(handles.axBodeMag);
    handles.axBodePhase.Visible = 'off';
    cla(handles.axBodePhase);
    handles.uiPanelBode.Title = ...
        'Bode Plot (Choose ''Response'' in menu)';
else
    hObject.Checked = 'on';
    plotBode(handles);
    handles.axBodeMag.Visible = 'on';
    handles.axBodePhase.Visible = 'on';
    handles.uiPanelBode.Title = 'Bode Plot (Frequency Response)';
end


% --------------------------------------------------------------------
function menuPlotImpulse_Callback(hObject, ~, handles)
if isequal(hObject.Checked,'on'),
    hObject.Checked = 'off';
    handles.axStep.Visible = 'off';
    cla(handles.axImpulse);
    handles.uiPanelImpulse.Title = ...
        'Impulse Response (Choose ''Response'' in menu)';
else
    hObject.Checked = 'on';
    plotImpulse(handles);
    handles.axImpulse.Visible = 'on';
    handles.uiPanelImpulse.Title = 'Impulse Response';
end


% --------------------------------------------------------------------
function makePlots(handles)
plotPZ(handles);
if isequal(handles.menuPlotStep.Checked,'on'),
    plotStep(handles);
end
if isequal(handles.menuPlotImpulse.Checked,'on'),
    plotImpulse(handles)
end
if isequal(handles.menuPlotBode.Checked,'on'),
    plotBode(handles)
end

% --------------------------------------------------------------------
function c = myColor(handles,i,j)
c = hsv2rgb([handles.zHord(i) handles.wSord(j) handles.wVord(j)]);
if i==length(handles.zcb)
    c = hsv2rgb([handles.zHord(i) handles.wSord(j) 0]);
end

% --------------------------------------------------------------------
function [n,d]=getND(handles,zeta,w0)
d=[1 2*zeta*w0 w0*w0];
if isequal(handles.ChooseLP.Checked,'on')
    n=[0 0 w0*w0];
elseif isequal(handles.ChooseHP.Checked,'on')
    n=[1 0 0];
elseif isequal(handles.ChooseBP.Checked,'on');
    n=[0 2*zeta*w0 0];
else
    n=[1 0 w0*w0];
end

% --------------------------------------------------------------------
function plotPZ(handles)
axes(handles.axPZ);  cla;
for i=1:length(handles.zcb),
    zeta = str2double(handles.zcb(i).String);
    for j=1:length(handles.wcb),
        w0 = str2double(handles.wcb(j).String);
        if handles.zcb(i).Value==1 && handles.wcb(j).Value==1,
            [n,d] = getND(handles,zeta,w0);
            p = roots(d);
            z = roots(n);
            c = myColor(handles,i,j);
            plot(real(p),imag(p),'x','Linewidth',...
                handles.wWidth(j),'MarkerEdgeColor',c);
            hold on;
            plot(real(z),imag(z),'o','Linewidth',...
                handles.wWidth(j),'MarkerEdgeColor',c);
        end
    end
end
axis([-4.1 0.1 -2.1 2.1]);
set(gca,'YAxisLocation','right');
axis('square');  xlabel('\sigma');  ylabel('j\omega');
set(gca,'Color',(1+handles.grey)/2);
if isequal(handles.menuSgrid.Checked,'on'),
    sgrid([0.2 0.4 0.6 0.8 0.9],[0.5 1.0 2.0 3.0 4.0]);
elseif isequal(handles.menuGrids.Checked,'on'),
    grid on;
else
    plot(get(gca,'XLim'),[0 0],':','Color',handles.grey/2);
    plot([0 0],get(gca,'YLim'),':','Color',handles.grey/2);
end
hold off

% --------------------------------------------------------------------
function plotStep(handles)
handles.axStep.Visible='on';
axes(handles.axStep);  cla;
Tfinal = 15;
for i=1:length(handles.zcb),
    zeta = str2double(handles.zcb(i).String);
    for j=1:length(handles.wcb),
        w0 = str2double(handles.wcb(j).String);
        if handles.zcb(i).Value==1 && handles.wcb(j).Value==1,
            [n,d] = getND(handles,zeta,w0);
            c = myColor(handles,i,j);
            [y,t] = step(tf(n,d),Tfinal);
            plot(t,y,'Color',c,'Linewidth',handles.wWidth(j));
            hold on;
            plot([-1 0 0],[0 0 y(1)],...  % plot section for t<=
                'Color',c,'Linewidth',handles.wWidth(j));
        end
    end
end
axis([-1 Tfinal -0.8 1.8]);
xlabel('Time');  ylabel('h(t)');
set(gca,'Color',(1+handles.grey)/2);
if isequal(handles.menuGrids.Checked,'on'),
    grid on;
else
    plot(get(gca,'XLim'),[0 0],':','Color',handles.grey/2);
    plot([0 0],get(gca,'YLim'),':','Color',handles.grey/2);
end
hold off

% --------------------------------------------------------------------
function plotImpulse(handles)
handles.axImpulse.Visible='on';
axes(handles.axImpulse);  cla;
Tfinal = 15;
for i=1:length(handles.zcb),
    zeta = str2double(handles.zcb(i).String);
    for j=1:length(handles.wcb),
        w0 = str2double(handles.wcb(j).String);
        if handles.zcb(i).Value==1 && handles.wcb(j).Value==1,
            [n,d] = getND(handles,zeta,w0);
            c = myColor(handles,i,j);
            [y,t] = impulse(tf(n,d),Tfinal);
            plot(t,y,'Color',c,'Linewidth',handles.wWidth(j));
            hold on;
            plot([-1 0 0],[0 0 y(1)],...  % plot section for t<=
                'Color',c,'Linewidth',handles.wWidth(j));
            if isequal(handles.ChooseHP.Checked,'on') || ...
                    isequal(handles.ChooseBR.Checked,'on'),
                plot([0 0],[0 1],...  % plot section for t<=
                    'Color',c,'Linewidth',handles.wWidth(j));
                plot(0,0.85,'^',...  % plot section for t<=
                    'Color',c,'Linewidth',handles.wWidth(j),...
                    'MarkerFaceColor',c,'MarkerEdgeColor',c);
            end
        end
    end
end

if isequal(handles.ChooseHP.Checked,'on'),
    axis([-1 Tfinal -4 2.1]);
elseif isequal(handles.ChooseBP.Checked,'on'),
    axis([-1 Tfinal -4 2.1]);
elseif isequal(handles.ChooseBR.Checked,'on'),
    axis([-1 Tfinal -4 2.1]);
else
    axis([-1 Tfinal -2 2.5]);
end

xlabel('Time');  ylabel('y_\gamma(t)');
set(gca,'Color',(1+handles.grey)/2);
if isequal(handles.menuGrids.Checked,'on'),
    grid on;
else
    plot(get(gca,'XLim'),[0 0],':','Color',handles.grey/2);
    plot([0 0],get(gca,'YLim'),':','Color',handles.grey/2);
end
hold off

% --------------------------------------------------------------------
function plotBode(handles)
handles.axBodeMag.Visible='on';
cla(handles.axBodeMag);
handles.axBodePhase.Visible='on';
cla(handles.axBodePhase);
wrng={0.01 100};
for i=1:length(handles.zcb),
    zeta = str2double(handles.zcb(i).String);
    for j=1:length(handles.wcb),
        w0 = str2double(handles.wcb(j).String);
        if handles.zcb(i).Value==1 && handles.wcb(j).Value==1,
            [n,d] = getND(handles,zeta,w0);
            c = myColor(handles,i,j);
            [m,p,w] = bode(tf(n,d),wrng);
            semilogx(handles.axBodeMag,w,20*log10(m(:)),...
                'Color',c,'Linewidth',handles.wWidth(j));
            hold(handles.axBodeMag, 'on');
            semilogx(handles.axBodePhase,w,p(:),'Color',c,...
                'Linewidth',handles.wWidth(j));
            hold(handles.axBodePhase, 'on');
        end
    end
end
axes(handles.axBodeMag);
handles.axBodeMag.Color = (1+handles.grey)/2;
handles.axBodeMag.XTickLabel=[];
if isequal(handles.menuGrids.Checked,'on'),
    grid on;
else
    semilogx(cell2mat(wrng),[0 0],':','Color',handles.grey/2);
end
ylabel('|H(j\omega)|, dB');
axis([wrng{1} wrng{2} -55 15]);
axes(handles.axBodePhase);
handles.axBodePhase.Color = (1+handles.grey)/2;
handles.axBodePhase.YTick=-180:45:180;
if isequal(handles.menuGrids.Checked,'on'),
    grid on;
else
    semilogx(cell2mat(wrng),[0 0],':','Color',handles.grey/2);
end
xlabel('\omega'); ylabel('Phase, \circ');
if isequal(handles.ChooseHP.Checked,'on'),
    axis([wrng{1} wrng{2} -5 180]);
elseif isequal(handles.ChooseBP.Checked,'on'),
    axis([wrng{1} wrng{2} -95 95]);
elseif isequal(handles.ChooseBR.Checked,'on'),
    axis([wrng{1} wrng{2} -95 95]);
else
    axis([wrng{1} wrng{2} -185 5]);
end

