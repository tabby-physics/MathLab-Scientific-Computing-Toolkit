function MathLabGUI
% MATHLABGUI  Interactive scientific computing calculator.
% Run MathLabGUI in MATLAB. Symbolic Math Toolbox is needed for the
% Calculus, Equations and Plotting tabs. No other project files are needed.

C.bg = [0.075 0.105 0.16];
C.panel = [0.12 0.17 0.24];
C.ink = [0.94 0.97 1];
C.muted = [0.67 0.76 0.85];
C.accent = [0.35 0.87 0.80];
C.field = [0.96 0.98 1];
C.dark = [0.09 0.14 0.21];

fig = uifigure('Name','MathLab | Scientific Computing Toolkit', ...
    'Position',[100 100 1060 680],'Color',C.bg);
root = uigridlayout(fig,[3 1]);
root.RowHeight = {76,'1x',28};
root.Padding = [18 14 18 10];
root.RowSpacing = 10;
root.BackgroundColor = C.bg;

head = uigridlayout(root,[2 1]);
head.RowHeight = {42,24}; head.Padding = [6 0 6 0];
head.RowSpacing = 2; head.BackgroundColor = C.bg;
label(head,'MathLab',C.accent,32,'bold');
label(head,'SCIENTIFIC COMPUTING TOOLKIT  /  MATLAB',C.muted,13,'normal');

tabs = uitabgroup(root);
sc = uitab(tabs,'Title','Scientific');
ma = uitab(tabs,'Title','Matrices');
ca = uitab(tabs,'Title','Calculus');
eq = uitab(tabs,'Title','Equations');
pl = uitab(tabs,'Title','Visualization');
label(root,'MathLab  |  Mathematics, programming and scientific visualization',C.muted,12,'normal');

% 1. SCIENTIFIC CALCULATOR
[L,R] = panels(sc,C,'Scientific calculator','Calculate using real numbers. Trigonometry uses degrees.');
ops = {'Addition','Subtraction','Multiplication','Division','Power', ...
    'Square root','Sine (degrees)','Cosine (degrees)','Tangent (degrees)', ...
    'Natural logarithm','Common logarithm','Exponential','Factorial','Absolute value'};
sOp = dropdown(L,'Operation',ops,C);
sA = field(L,'First number','30',C);
sB = field(L,'Second number (for first five operations)','2',C);
sNote = label(L,'Choose an operation, then calculate.',C.muted,12,'normal');
sNote.WordWrap = 'on';
sOut = resultPanel(R,C,'NUMERICAL RESULT','Your answer will appear here.');
button(L,'Calculate',@(~,~) scientificRun(sOp,sA,sB,sOut),C);
button(L,'Reset',@(~,~) resetScientific(sOp,sA,sB,sOut),C,true);
sOp.ValueChangedFcn = @(~,~) updateSecond(sOp,sB,ops(1:5));
updateSecond(sOp,sB,ops(1:5));

% 2. MATRIX CALCULATOR
[L,R] = panels(ma,C,'Matrix calculator','Enter rows separated by semicolons, e.g. [1 2; 3 4].');
mOps = {'Addition','Subtraction','Multiplication','Transpose','Determinant', ...
    'Inverse','Rank','Eigenvalues','RREF','Trace'};
mOp = dropdown(L,'Operation',mOps,C); mOp.Value = 'Determinant';
mA = field(L,'Matrix A','[1 2; 3 4]',C);
mB = field(L,'Matrix B (for first three operations)','[5 6; 7 8]',C);
mOut = resultPanel(R,C,'MATRIX RESULT','Example: determinant of [1 2; 3 4] is -2.');
button(L,'Calculate',@(~,~) matrixRun(mOp,mA,mB,mOut),C);
button(L,'Reset',@(~,~) resetMatrix(mOp,mA,mB,mOut),C,true);
mOp.ValueChangedFcn = @(~,~) updateSecond(mOp,mB,mOps(1:3));
updateSecond(mOp,mB,mOps(1:3));

% 3. CALCULUS
[L,R] = panels(ca,C,'Calculus solver','Use x as the variable and * for multiplication.');
cOps = {'Differentiation','Indefinite integration','Definite integration', ...
    'Higher-order derivative','Limit'};
cOp = dropdown(L,'Operation',cOps,C);
cF = field(L,'Function f(x)','x^3+2*x^2',C);
cA = field(L,'Lower bound / derivative order / limit point','0',C);
cB = field(L,'Upper bound (definite integral only)','3',C);
cOut = resultPanel(R,C,'SYMBOLIC RESULT','Example: derivative of x^3 is 3*x^2.');
button(L,'Calculate',@(~,~) calculusRun(cOp,cF,cA,cB,cOut),C);
button(L,'Reset',@(~,~) resetCalculus(cOp,cF,cA,cB,cOut),C,true);
cOp.ValueChangedFcn = @(~,~) updateCalculus(cOp,cA,cB);
updateCalculus(cOp,cA,cB);

% 4. EQUATIONS
[L,R] = panels(eq,C,'Equation solver','Write equality with ==, e.g. x^2-5*x+6==0.');
eOps = {'Linear equation','Quadratic equation','Cubic equation', ...
    'Simultaneous equations','Numerical nonlinear equation'};
eOp = dropdown(L,'Operation',eOps,C); eOp.Value = 'Quadratic equation';
eA = field(L,'Equation 1 (use x, or x and y)','x^2-5*x+6==0',C);
eB = field(L,'Equation 2 (simultaneous only)','x-y==1',C);
eG = field(L,'Initial guess (numerical only)','1',C);
eOut = resultPanel(R,C,'EQUATION SOLUTIONS','Example: x^2-5*x+6==0 has roots 2 and 3.');
button(L,'Solve equations',@(~,~) equationRun(eOp,eA,eB,eG,eOut),C);
button(L,'Reset',@(~,~) resetEquation(eOp,eA,eB,eG,eOut),C,true);
eOp.ValueChangedFcn = @(~,~) updateEquation(eOp,eB,eG);
updateEquation(eOp,eB,eG);

% 5. FUNCTION VISUALIZATION
[L,R] = panels(pl,C,'Function visualization','2D functions use x; surfaces and contours use x and y.');
pOps = {'Single 2D function','Compare two functions','3D surface','Contour plot'};
pOp = dropdown(L,'Plot type',pOps,C);
pF = field(L,'First function','sin(x)',C);
pG = field(L,'Second function (comparison only)','cos(x)',C);
pA = field(L,'Minimum coordinate','-10',C);
pB = field(L,'Maximum coordinate','10',C);
R.RowHeight = {30,'1x',40};
label(R,'FUNCTION VISUALIZATION',C.accent,14,'bold');
ax = uiaxes(R,'Color',C.panel,'XColor',C.muted,'YColor',C.muted,'ZColor',C.muted);
styleAxes(ax,C);
pStatus = label(R,'Enter a function and select Generate graph.',C.muted,12,'normal');
pStatus.WordWrap = 'on';
button(L,'Generate graph',@(~,~) plotRun(pOp,pF,pG,pA,pB,ax,pStatus,C),C);
button(L,'Reset graph',@(~,~) resetPlot(pOp,pF,pG,pA,pB,ax,pStatus,C),C,true);
pOp.ValueChangedFcn = @(~,~) updatePlot(pOp,pF,pG);
updateSecond(pOp,pG,{'Compare two functions'});
end

% -------------------------- UI helpers -------------------------------
function [L,R] = panels(tab,C,heading,hint)
g = uigridlayout(tab,[1 2]);
g.ColumnWidth = {350,'1x'}; g.ColumnSpacing = 12;
g.Padding = [12 12 12 12]; g.BackgroundColor = C.bg;
L = uigridlayout(g,[15 1]); L.Layout.Column = 1;
L.Padding = [14 10 14 10]; L.RowSpacing = 3; L.BackgroundColor = C.panel;
% Controls flow down the grid in creation order.
L.RowHeight = repmat({26},1,15);
L.RowHeight{1} = 34; L.RowHeight{2} = 40; L.RowHeight{15} = '1x';
R = uigridlayout(g,[3 1]); R.Layout.Column = 2;
R.RowHeight = {30,'1x',28}; R.Padding = [14 12 14 12];
R.BackgroundColor = C.panel;
label(L,heading,C.ink,20,'bold');
h = label(L,hint,C.muted,12,'normal'); h.WordWrap = 'on';
end

function h = label(parent,str,col,sz,weight)
h = uilabel(parent,'Text',str,'FontColor',col,'FontSize',sz,'FontWeight',weight);
end

function h = field(parent,caption,value,C)
label(parent,caption,C.muted,12,'normal');
h = uieditfield(parent,'text','Value',value,'FontSize',14, ...
    'BackgroundColor',C.field,'FontColor',C.dark);
end

function h = dropdown(parent,caption,items,C)
label(parent,caption,C.muted,12,'normal');
h = uidropdown(parent,'Items',items,'FontSize',13, ...
    'BackgroundColor',C.field,'FontColor',C.dark);
end

function button(parent,str,cb,C,secondary)
if nargin < 5, secondary = false; end
if secondary, bg = [0.23 0.32 0.42]; fg = C.ink;
else, bg = C.accent; fg = C.dark; end
uibutton(parent,'push','Text',str,'ButtonPushedFcn',cb, ...
    'BackgroundColor',bg,'FontColor',fg,'FontWeight','bold','FontSize',14);
end

function h = resultPanel(parent,C,heading,hint)
label(parent,heading,C.accent,14,'bold');
h = uitextarea(parent,'Editable','off','Value',{hint}, ...
    'FontName','Courier New','FontSize',17, ...
    'BackgroundColor',C.bg,'FontColor',C.ink);
label(parent,'Results appear here without using the Command Window.',C.muted,12,'normal');
end

function show(out,str)
out.Value = cellstr(splitlines(string(str)));
end

function updateSecond(op,h,allowed)
h.Enable = onOff(ismember(op.Value,allowed));
end

function s = onOff(flag)
if flag, s = 'on'; else, s = 'off'; end
end

function updateCalculus(op,a,b)
a.Enable = onOff(ismember(op.Value,{'Definite integration','Higher-order derivative','Limit'}));
b.Enable = onOff(strcmp(op.Value,'Definite integration'));
end

function updateEquation(op,b,g)
b.Enable = onOff(strcmp(op.Value,'Simultaneous equations'));
g.Enable = onOff(strcmp(op.Value,'Numerical nonlinear equation'));
end

function updatePlot(op,f,g)
updateSecond(op,g,{'Compare two functions'});
if strcmp(op.Value,'3D surface')
    f.Value = 'sin(sqrt(x^2+y^2))';
elseif strcmp(op.Value,'Contour plot')
    f.Value = 'x^2+y^2';
else
    f.Value = 'sin(x)';
end
end

% --------------------------- Scientific ------------------------------
function scientificRun(op,fa,fb,out)
try
    a = realNumber(fa.Value);
    if ismember(op.Value,{'Addition','Subtraction','Multiplication','Division','Power'})
        b = realNumber(fb.Value);
    end
    switch op.Value
        case 'Addition', r = a+b;
        case 'Subtraction', r = a-b;
        case 'Multiplication', r = a*b;
        case 'Division'
            if b==0, error('Division by zero is undefined.'); end
            r = a/b;
        case 'Power', r = a^b;
        case 'Square root'
            if a<0, error('Enter a nonnegative number.'); end
            r = sqrt(a);
        case 'Sine (degrees)', r = sind(a);
        case 'Cosine (degrees)', r = cosd(a);
        case 'Tangent (degrees)'
            if abs(cosd(a))<1e-12, error('Tangent is undefined at this angle.'); end
            r = tand(a);
        case 'Natural logarithm'
            if a<=0, error('Logarithms require a positive number.'); end
            r = log(a);
        case 'Common logarithm'
            if a<=0, error('Logarithms require a positive number.'); end
            r = log10(a);
        case 'Exponential', r = exp(a);
        case 'Factorial'
            if a<0 || a>170 || a~=floor(a), error('Enter an integer from 0 to 170.'); end
            r = factorial(a);
        case 'Absolute value', r = abs(a);
    end
    if ~isreal(r) || ~isfinite(r), error('Result is outside the supported real range.'); end
    show(out,sprintf('%s\n\nResult = %.12g',op.Value,r));
catch ME
    show(out,['Error: ' ME.message]);
end
end

function v = realNumber(txt)
v = str2double(txt);
if ~isscalar(v) || ~isreal(v) || ~isfinite(v)
    error('Enter a valid finite real number.');
end
end

function resetScientific(op,a,b,out)
op.Value='Addition'; a.Value='30'; b.Value='2';
updateSecond(op,b,{'Addition','Subtraction','Multiplication','Division','Power'});
show(out,'Your answer will appear here.');
end

% ----------------------------- Matrices ------------------------------
function matrixRun(op,fa,fb,out)
try
    A = parseMatrix(fa.Value);
    if ismember(op.Value,{'Addition','Subtraction','Multiplication'})
        B = parseMatrix(fb.Value);
    end
    if ismember(op.Value,{'Determinant','Inverse','Eigenvalues','Trace'}) && size(A,1)~=size(A,2)
        error('This operation requires a square matrix.');
    end
    switch op.Value
        case 'Addition'
            if ~isequal(size(A),size(B)), error('Matrix dimensions must match.'); end
            r=A+B;
        case 'Subtraction'
            if ~isequal(size(A),size(B)), error('Matrix dimensions must match.'); end
            r=A-B;
        case 'Multiplication'
            if size(A,2)~=size(B,1), error('Columns of A must equal rows of B.'); end
            r=A*B;
        case 'Transpose', r=A.';
        case 'Determinant', r=det(A);
        case 'Inverse'
            if rcond(A)<1e-12, error('Matrix is singular or nearly singular.'); end
            r=inv(A);
        case 'Rank', r=rank(A);
        case 'Eigenvalues', r=eig(A);
        case 'RREF', r=rref(A);
        case 'Trace', r=trace(A);
    end
    show(out,sprintf('%s\n\n%s',op.Value,displayValue(r)));
catch ME
    show(out,['Error: ' ME.message]);
end
end

function A = parseMatrix(txt)
% Numeric literals only: no eval, no executable MATLAB expressions.
txt=strtrim(txt);
if ~isempty(txt) && txt(1)=='[' && txt(end)==']'
    txt=txt(2:end-1);
end
rows=regexp(txt,';','split');
A=[];
for k=1:numel(rows)
    row=strtrim(rows{k});
    if isempty(row), error('Matrix rows cannot be empty.'); end
    tokens=regexp(row,'[\s,]+','split');
    vals=str2double(tokens);
    if any(~isfinite(vals)) || ~isreal(vals)
        error('Use finite real matrix entries, e.g. [1 2; 3 4].');
    end
    if k>1 && numel(vals)~=size(A,2)
        error('Every matrix row must have the same number of entries.');
    end
    A=[A; vals]; %#ok<AGROW>
end
end

function resetMatrix(op,a,b,out)
op.Value='Determinant'; a.Value='[1 2; 3 4]'; b.Value='[5 6; 7 8]';
updateSecond(op,b,{'Addition','Subtraction','Multiplication'});
show(out,'Example: determinant of [1 2; 3 4] is -2.');
end

% ----------------------------- Calculus ------------------------------
function calculusRun(op,ff,fa,fb,out)
try
    requireSymbolic;
    syms x
    f=str2sym(ff.Value); checkVars(f,{'x'});
    switch op.Value
        case 'Differentiation', r=diff(f,x);
        case 'Indefinite integration', r=int(f,x);
        case 'Definite integration'
            a=str2sym(fa.Value); b=str2sym(fb.Value);
            checkVars(a,{}); checkVars(b,{}); r=int(f,x,a,b);
        case 'Higher-order derivative'
            n=realNumber(fa.Value);
            if n<1 || n~=floor(n) || n>50, error('Enter an integer order from 1 to 50.'); end
            r=diff(f,x,n);
        case 'Limit'
            a=str2sym(fa.Value); checkVars(a,{}); r=limit(f,x,a);
    end
    ansText=displayValue(r);
    if strcmp(op.Value,'Indefinite integration'), ansText=[ansText ' + C']; end
    show(out,sprintf('%s\n\nf(x) = %s\n\n%s',op.Value,char(f),ansText));
catch ME
    show(out,['Error: ' ME.message]);
end
end

function resetCalculus(op,f,a,b,out)
op.Value='Differentiation'; f.Value='x^3+2*x^2'; a.Value='0'; b.Value='3';
updateCalculus(op,a,b); show(out,'Example: derivative of x^3 is 3*x^2.');
end

% ----------------------------- Equations -----------------------------
function equationRun(op,fa,fb,fg,out)
try
    requireSymbolic;
    syms x y
    e1=str2sym(fa.Value);
    switch op.Value
        case 'Simultaneous equations'
            e2=str2sym(fb.Value);
            checkVars(e1,{'x','y'}); checkVars(e2,{'x','y'});
            [sx,sy]=solve([e1,e2],[x,y]);
            if isempty(sx) || isempty(sy)
                answer='No explicit solution returned.';
            else
                answer=sprintf('x =\n%s\n\ny =\n%s',displayValue(sx),displayValue(sy));
            end
        case 'Numerical nonlinear equation'
            checkVars(e1,{'x'});
            r=vpasolve(e1,x,realNumber(fg.Value));
            if isempty(r), answer='No numerical root found. Try another initial guess.';
            else, answer=sprintf('Approximate x =\n%s',displayValue(vpa(r,10))); end
        otherwise
            checkVars(e1,{'x'});
            r=solve(e1,x);
            if isempty(r), answer='No explicit solution returned.';
            else, answer=sprintf('x =\n%s',displayValue(r)); end
    end
    show(out,sprintf('%s\n\n%s',op.Value,answer));
catch ME
    show(out,['Error: ' ME.message]);
end
end

function resetEquation(op,a,b,g,out)
op.Value='Quadratic equation'; a.Value='x^2-5*x+6==0'; b.Value='x-y==1'; g.Value='1';
updateEquation(op,b,g); show(out,'Example: x^2-5*x+6==0 has roots 2 and 3.');
end

% ----------------------------- Plotting ------------------------------
function plotRun(op,ff,fg,fa,fb,ax,status,C)
try
    requireSymbolic;
    syms x y
    f=str2sym(ff.Value);
    a=realNumber(fa.Value); b=realNumber(fb.Value);
    if a>=b, error('Minimum must be smaller than maximum.'); end
    cla(ax,'reset'); legend(ax,'off'); colorbar(ax,'off');
    switch op.Value
        case {'Single 2D function','Compare two functions'}
            checkVars(f,{'x'});
            fh=matlabFunction(f,'Vars',{x});
            fplot(ax,@(t) realGrid(fh(t),size(t)),[a b],'LineWidth',2.4,'Color',C.accent);
            if strcmp(op.Value,'Compare two functions')
                g=str2sym(fg.Value); checkVars(g,{'x'});
                gh=matlabFunction(g,'Vars',{x}); hold(ax,'on');
                fplot(ax,@(t) realGrid(gh(t),size(t)),[a b],'LineWidth',2.1,'Color',[1 0.65 0.32]);
                hold(ax,'off');
                lg=legend(ax,{char(f),char(g)},'Interpreter','none','Location','best');
                lg.TextColor=C.ink; lg.Color=C.panel;
            end
            view(ax,2); xlabel(ax,'x'); ylabel(ax,'f(x)'); title(ax,op.Value);
        otherwise
            checkVars(f,{'x','y'});
            fh=matlabFunction(f,'Vars',{x,y});
            [X,Y]=meshgrid(linspace(a,b,120));
            Z=realGrid(fh(X,Y),size(X));
            if all(isnan(Z(:))), error('Function has no finite real values in this range.'); end
            if strcmp(op.Value,'3D surface')
                surf(ax,X,Y,Z,'EdgeColor','none'); view(ax,45,30); zlabel(ax,'f(x,y)');
                colormap(ax,parula(256));
            else
                contourf(ax,X,Y,Z,25,'LineColor','none'); view(ax,2);
                colormap(ax,turbo(256));
            end
            xlabel(ax,'x'); ylabel(ax,'y'); title(ax,op.Value);
            cb=colorbar(ax); cb.Color=C.muted;
    end
    styleAxes(ax,C);
    status.Text='Graph generated. Change inputs to explore another function.';
    status.FontColor=C.accent;
catch ME
    hold(ax,'off'); styleAxes(ax,C);
    status.Text=['Error: ' ME.message]; status.FontColor=[1 0.65 0.65];
end
end

function Z=realGrid(Z,sz)
if isscalar(Z), Z=repmat(Z,sz); end
Z(imag(Z)~=0 | ~isfinite(Z))=NaN;
Z=real(Z);
end

function styleAxes(ax,C)
ax.Color=C.panel; ax.XColor=C.muted; ax.YColor=C.muted; ax.ZColor=C.muted;
ax.GridColor=C.muted; ax.GridAlpha=0.18; ax.FontSize=12;
ax.Title.Color=C.ink; grid(ax,'on'); box(ax,'on');
end

function resetPlot(op,f,g,a,b,ax,status,C)
op.Value='Single 2D function'; f.Value='sin(x)'; g.Value='cos(x)'; a.Value='-10'; b.Value='10';
updateSecond(op,g,{'Compare two functions'});
cla(ax,'reset'); legend(ax,'off'); colorbar(ax,'off'); styleAxes(ax,C);
status.Text='Enter a function and select Generate graph.'; status.FontColor=C.muted;
end

% -------------------------- Shared utilities -------------------------
function requireSymbolic
if isempty(which('str2sym'))
    error('Symbolic Math Toolbox is required for this feature.');
end
end

function checkVars(expr,allowed)
vars=symvar(expr);
for k=1:numel(vars)
    if ~ismember(char(vars(k)),allowed)
        error('Unexpected variable: %s. Use only the variables listed in the input hint.',char(vars(k)));
    end
end
end

function txt=displayValue(v)
if isnumeric(v)
    txt=strtrim(evalc('disp(v)'));
else
    if isscalar(v), txt=char(v);
    else
        parts=cell(numel(v),1);
        for k=1:numel(v), parts{k}=char(v(k)); end
        txt=strjoin(parts,newline);
    end
end
end
