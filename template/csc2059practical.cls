% csc2059practical.cls
% Reusable LaTeX class for CSC2059 Data Structures and Algorithms practical guides
% Version: 0.6

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{csc2059practical}[2026/07/01 CSC2059 practical guide class v0.6]

\LoadClass[11pt,a4paper]{article}

% ------------------------------------------------------------
% Page layout and typography
% ------------------------------------------------------------
\RequirePackage[a4paper,margin=25mm,headheight=34pt,headsep=8mm,footskip=14mm]{geometry}
\RequirePackage{iftex}

\ifPDFTeX
  \RequirePackage[T1]{fontenc}
  \RequirePackage[utf8]{inputenc}
  \RequirePackage{lmodern}
\else
  \RequirePackage{fontspec}
  % Use the preferred fonts when available. If a font is unavailable,
  % do not force a named fallback: LuaLaTeX already defaults to Latin
  % Modern, and forcing a missing fallback can create noisy fontspec errors.
  \IfFontExistsTF{TeX Gyre Pagella}{\setmainfont{TeX Gyre Pagella}}{}
  \IfFontExistsTF{TeX Gyre Heros}{\setsansfont{TeX Gyre Heros}}{}
  \IfFontExistsTF{Inconsolata}{\setmonofont{Inconsolata}}{}
\fi

\RequirePackage{microtype}
\RequirePackage{parskip}
\RequirePackage{setspace}
\RequirePackage{needspace}
\onehalfspacing


% ------------------------------------------------------------
% Colour, links, headings, headers
% ------------------------------------------------------------
\RequirePackage{xcolor}
\definecolor{CSCBlue}{HTML}{003366}
\definecolor{CSCLightBlue}{HTML}{EAF2F8}
\definecolor{CSCGreen}{HTML}{2E7D32}
\definecolor{CSCLightGreen}{HTML}{EAF7EA}
\definecolor{CSCAmber}{HTML}{B26A00}
\definecolor{CSCLightAmber}{HTML}{FFF4E0}
\definecolor{CSCRed}{HTML}{9A1B1E}
\definecolor{CSCLightRed}{HTML}{FBEAEA}
\definecolor{CSCPurple}{HTML}{5E3C99}
\definecolor{CSCLightPurple}{HTML}{F1ECFA}
\definecolor{CSCGray}{HTML}{F5F5F5}
\definecolor{CSCCodeFrame}{HTML}{D6D6D6}

\definecolor{CSCEngineering}{HTML}{5C4B8A}
\definecolor{CSCLightEngineering}{HTML}{F0ECF8}



%  For Git
\definecolor{GitGreen}{RGB}{40,167,69}
\definecolor{GitRed}{RGB}{220,53,69}

\RequirePackage[hidelinks]{hyperref}
\hypersetup{
  colorlinks=true,
  linkcolor=CSCBlue,
  urlcolor=CSCBlue,
  citecolor=CSCBlue,
  pdftitle={CSC2059 Practical Guide},
  pdfauthor={Queen's University Belfast}
}

\RequirePackage{titlesec}
\titleformat{\section}{\Large\bfseries\sffamily\color{CSCBlue}}{\thesection}{0.75em}{}
\titleformat{\subsection}{\large\bfseries\sffamily\color{CSCBlue}}{\thesubsection}{0.75em}{}
\titleformat{\subsubsection}{\normalsize\bfseries\sffamily\color{CSCBlue}}{\thesubsubsection}{0.75em}{}

%%  Custom commands
% adds a new section that doesn't increment the section count,
% but stll appears in the TOC
\newcommand{\frontsection}[1]{

    \section*{#1}

    \addcontentsline{toc}{section}{#1}

}


% A command to create a workflow of 7 levels
\newcommand{\VerticalWorkflowSeven}[7]{%
\begin{figure}[H]
\centering
\begin{tikzpicture}[
    workflowstep/.style={
        rounded corners,
        draw=CSCBlue,
        fill=CSCBlue!6,
        very thick,
        minimum width=5cm,
        minimum height=1cm,
        align=center,
        font=\bfseries
    },
    workflowarrow/.style={
        -{Latex[length=3mm]},
        very thick,
        draw=CSCBlue
    },
    node distance=6mm
]
\node[workflowstep] (s1) {#1};
\node[workflowstep, below=of s1] (s2) {#2};
\node[workflowstep, below=of s2] (s3) {#3};
\node[workflowstep, below=of s3] (s4) {#4};
\node[workflowstep, below=of s4] (s5) {#5};
\node[workflowstep, below=of s5] (s6) {#6};
\node[workflowstep, below=of s6] (s7) {#7};

\draw[workflowarrow] (s1) -- (s2);
\draw[workflowarrow] (s2) -- (s3);
\draw[workflowarrow] (s3) -- (s4);
\draw[workflowarrow] (s4) -- (s5);
\draw[workflowarrow] (s5) -- (s6);
\draw[workflowarrow] (s6) -- (s7);
\end{tikzpicture}
\end{figure}
}


% Prevents section headings being left orphan.
\let\CSCOriginalSection\section
\renewcommand{\section}{%
  \Needspace{10\baselineskip}%
  \CSCOriginalSection%
}



% Header and footer are configured after the practical metadata is defined.
\RequirePackage{fancyhdr}

% ------------------------------------------------------------
% Lists, tables, graphics
% ------------------------------------------------------------
\RequirePackage{enumitem}
\setlist[itemize]{topsep=3pt,itemsep=2pt,parsep=0pt}
\setlist[enumerate]{topsep=3pt,itemsep=2pt,parsep=0pt}
\RequirePackage{booktabs}
\RequirePackage{graphicx}
\RequirePackage{tikz}
\RequirePackage{tabularx}
\RequirePackage{booktabs}
\usetikzlibrary{shapes.geometric,
                arrows.meta,
                backgrounds,
                calc, 
                positioning,
                quotes
                }

% ------------------------------------------------------------
% Code listings
% ------------------------------------------------------------
\RequirePackage{minted}
\setminted{
  fontsize=\small,
  breaklines=true,
  autogobble=true,
  frame=lines,
  framesep=2mm,
  rulecolor=\color{CSCCodeFrame}
}

\newenvironment{cppcode}
  {\VerbatimEnvironment\begin{minted}{cpp}}
  {\end{minted}}

\newenvironment{bashcode}
  {\VerbatimEnvironment\begin{minted}{bash}}
  {\end{minted}}

\newenvironment{terminal}
  {\VerbatimEnvironment\begin{minted}{text}}
  {\end{minted}}


% ------------------------------------------------------------
% High-visibility FontAwesome icons and callout boxes
% ------------------------------------------------------------
% FontAwesome gives clean, professional icons with correct proportions.
% These are intentionally template-level choices so individual practical
% files do not need to manage icons manually.
\RequirePackage{fontawesome5}

\newcommand{\cscFAIcon}[2]{%
  \raisebox{-0.22\height}{\makebox[18mm][c]{%
    {\fontsize{30}{30}\selectfont\textcolor{#1}{#2}}%
  }}%
}

\newcommand{\cscIconLearning}{\cscFAIcon{CSCBlue}{\faBullseye}}
\newcommand{\cscIconWorkflow}{\cscFAIcon{CSCPurple}{\faRecycle}}
\newcommand{\cscIconWarning}{\cscFAIcon{CSCAmber}{\faExclamationTriangle}}
\newcommand{\cscIconTip}{\cscFAIcon{CSCGreen}{\faLightbulb[regular]}}
\newcommand{\cscIconStop}{\cscFAIcon{CSCRed}{\faBan}}
\newcommand{\cscIconChallenge}{\cscFAIcon{CSCBlue}{\faDumbbell}}
\newcommand{\cscIconTerminal}{\cscFAIcon{orange!85!black}{\faTerminal}}
\newcommand{\cscIconReflection}{\cscFAIcon{teal!70!black}{\faQuestionCircle[regular]}}
\newcommand{\cscIconWrapUp}{\cscFAIcon{CSCGreen}{\faCheckCircle[regular]}}
\newcommand{\cscIconInfo}{\cscFAIcon{black!65}{\faInfoCircle}}
\newcommand{\cscIconEngineering}{%
  {\fontsize{26}{26}\selectfont\color{CSCEngineering}\faCogs}%
}

% ------------------------------------------------------------
% Callout boxes
% ------------------------------------------------------------
\RequirePackage[most]{tcolorbox}

\newtcolorbox{csccalloutbase}[5][]{%
  enhanced,
  breakable,
  colback=#3,
  colframe=#2,
  coltitle=#2,
  boxrule=0.8pt,
  arc=2mm,
  outer arc=2mm,
  left=25mm,
  right=4mm,
  top=4mm,
  bottom=4mm,
  before skip=8pt,
  after skip=8pt,
  overlay unbroken={\node[anchor=north west] at ([xshift=5mm,yshift=-5mm]frame.north west) {#5};},
  overlay first={\node[anchor=north west] at ([xshift=5mm,yshift=-5mm]frame.north west) {#5};},
  before upper={\par\noindent{\sffamily\bfseries\large\textcolor{#2}{#4}}\par\vspace{2mm}},
  #1
}

\newenvironment{engineeringquestion}[1][Engineering Question]
{\begin{csccalloutbase}{CSCEngineering}{CSCLightEngineering}{#1}{\cscIconEngineering}}
{\end{csccalloutbase}}

\newenvironment{learningoutcomes}
  {\begin{csccalloutbase}{CSCBlue}{CSCLightBlue}{Learning Outcomes}{\cscIconLearning}}
  {\end{csccalloutbase}}

\newenvironment{workflowreminder}
  {\begin{csccalloutbase}{CSCPurple}{CSCLightPurple}{Workflow Reminder}{\cscIconWorkflow}}
  {\end{csccalloutbase}}

\newenvironment{importantnote}
  {\begin{csccalloutbase}{CSCAmber}{CSCLightAmber}{Important Note}{\cscIconWarning}}
  {\end{csccalloutbase}}

\newenvironment{tipbox}
  {\begin{csccalloutbase}{CSCGreen}{CSCLightGreen}{Tip}{\cscIconTip}}
  {\end{csccalloutbase}}

\newenvironment{commonerror}
  {\begin{csccalloutbase}{CSCRed}{CSCLightRed}{Common Error}{\cscIconStop}}
  {\end{csccalloutbase}}

\newenvironment{challengebox}
  {\begin{csccalloutbase}{CSCBlue}{CSCLightBlue}{Challenge (Optional)}{\cscIconChallenge}}
  {\end{csccalloutbase}}

\newenvironment{reflectionbox}
  {\begin{csccalloutbase}{teal!70!black}{cyan!5}{Reflection}{\cscIconReflection}}
  {\end{csccalloutbase}}

\newenvironment{wrapupbox}
  {\begin{csccalloutbase}{CSCGreen}{CSCLightGreen}{Wrap-up}{\cscIconWrapUp}}
  {\end{csccalloutbase}}

\newenvironment{infobox}[1][General Information]
  {\begin{csccalloutbase}{black!65}{CSCGray}{#1}{\cscIconInfo}}
  {\end{csccalloutbase}}

% ------------------------------------------------------------
% Exercise command
% ------------------------------------------------------------
\newcounter{exercise}
\newcommand{\exercise}[2]{%
  \refstepcounter{exercise}%
  \section*{Exercise \theexercise: #1 \hfill \normalsize\textit{#2}}%
  \addcontentsline{toc}{section}{Exercise \theexercise: #1}%
}

\newenvironment{exerciseobjectives}{
  \subsection*{Learning objectives for this exercise}
  \begin{itemize}
}{
  \end{itemize}
}

% ------------------------------------------------------------
% Metadata and title page
% ------------------------------------------------------------
\newcommand{\modulecode}{CSC2059}
\newcommand{\moduletitle}{Data Structures and Algorithms}
\newcommand{\practicaltitle}{Practical Guide}
\newcommand{\practicalsubtitle}{C++ Practical}
\newcommand{\practicalnumber}{X}
\newcommand{\practicalauthor}{Dr Giuseppe Trombino, School of Electronics, Electrical Engineering and Computer Science}
\newcommand{\practicaldate}{\today}
\newcommand{\schoolname}{School of Electronics, Electrical Engineering and Computer Science}
\newcommand{\cscLogoFile}{qub-logo.pdf}
\newcommand{\cscLogoHeight}{0.82cm}

\newcommand{\setmodulecode}[1]{\renewcommand{\modulecode}{#1}}
\newcommand{\setmoduletitle}[1]{\renewcommand{\moduletitle}{#1}}
\newcommand{\setpracticaltitle}[1]{\renewcommand{\practicaltitle}{#1}}
\newcommand{\setpracticalsubtitle}[1]{\renewcommand{\practicalsubtitle}{#1}}
\newcommand{\setpracticalnumber}[1]{\renewcommand{\practicalnumber}{#1}}
\newcommand{\setpracticalauthor}[1]{\renewcommand{\practicalauthor}{#1}}
\newcommand{\setpracticaldate}[1]{\renewcommand{\practicaldate}{#1}}
\newcommand{\setschoolname}[1]{\renewcommand{\schoolname}{#1}}
\newcommand{\setcscLogoFile}[1]{\renewcommand{\cscLogoFile}{#1}}
\newcommand{\setcscLogoHeight}[1]{\renewcommand{\cscLogoHeight}{#1}}

% ------------------------------------------------------------
% CSC2059 branding, header, and footer
% ------------------------------------------------------------
\newcommand{\cscLogo}{%
  \IfFileExists{\cscLogoFile}{%
    \includegraphics[height=\cscLogoHeight]{\cscLogoFile}%
  }{%
    \sffamily\bfseries\color{CSCBlue}\modulecode%
  }%
}

\newcommand{\cscHeaderTitle}{%
  \sffamily\small
  \sffamily\bfseries\color{CSCBlue}\modulecode%
  \textbf{ Practical \practicalnumber}\\[-1pt]
  \practicaltitle
}

\pagestyle{fancy}
\fancyhf{}
\fancyhead[L]{\cscLogo}
\fancyhead[R]{\begin{minipage}[b]{0.62\textwidth}\raggedleft\cscHeaderTitle\end{minipage}}
\fancyfoot[L]{\footnotesize\schoolname}
\fancyfoot[R]{\footnotesize\thepage}
\renewcommand{\headrulewidth}{0.4pt}
\renewcommand{\footrulewidth}{0.4pt}

\fancypagestyle{plain}{%
  \fancyhf{}%
  \fancyhead[L]{\cscLogo}%
  \fancyhead[R]{\begin{minipage}[b]{0.62\textwidth}\raggedleft\cscHeaderTitle\end{minipage}}%
  \fancyfoot[L]{\footnotesize\schoolname}%
  \fancyfoot[R]{\footnotesize\thepage}%
  \renewcommand{\headrulewidth}{0.4pt}%
  \renewcommand{\footrulewidth}{0.4pt}%
}

\renewcommand{\maketitle}{%
  \begin{titlepage}
    \centering
    \vspace*{22mm}
    {\sffamily\bfseries\Huge\color{CSCBlue}\modulecode\\[3mm]}
    {\sffamily\Large\moduletitle\\[18mm]}
    {\sffamily\bfseries\huge Practical \practicalnumber\\[4mm]}
    {\sffamily\bfseries\LARGE\practicaltitle\\[3mm]}
    {\sffamily\large\practicalsubtitle\\[20mm]}
    \vfill
    {\large\practicalauthor\\[3mm]}
    {\large\practicaldate}
  \end{titlepage}
}

% ------------------------------------------------------------
% Appendix helper
% ------------------------------------------------------------
\newcommand{\startappendices}{%
  \clearpage
  \appendix
  \section*{Appendices}
  \addcontentsline{toc}{section}{Appendices}
}
