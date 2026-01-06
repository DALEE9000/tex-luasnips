local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local c = ls.choice_node
local i = ls.insert_node
local f = ls.function_node
local t = ls.text_node
local d = ls.dynamic_node
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

-- Helper for math mode
local function math()
	return vim.api.nvim_eval('vimtex#syntax#in_mathzone()') == 1
end 

-- Helper for visual selection or fallback insert node
local function visual_body(fallback_index)
	return f(function(_, snip)
		local sel = snip.env.LS_SELECT_RAW
		if not sel or sel == "" then
			return i(fallback_index)
		end
		local lines = type(sel) == "table" and sel or { sel }
		return table.concat(lines, "\n")
	end)
end

-- Helper for dynamic matrix generation
local generate_matrix = function(args, snip)
	local rows = tonumber(snip.captures[2])
	local cols = tonumber(snip.captures[3])
	local nodes = {}
	local ins_indx = 1
	local indent = "\t"
	for j = 1, rows do
		table.insert(nodes, r(ins_indx, tostring(j) .. "x1", i(1)))
		ins_indx = ins_indx + 1
		for k = 2, cols do
			table.insert(nodes, t(" & "))
			table.insert(nodes, r(ins_indx, tostring(j) .. "x" .. tostring(k), i(1)))
			ins_indx = ins_indx + 1
		end
		table.insert(nodes, t({ "\\\\", "" }))
		table.insert(nodes, t({ indent }))
	end
	-- fix last node.
	nodes[#nodes] = t("\\\\")
	return sn(nil, nodes)
end

-- Helper for dynamic table generation
local generate_table = function(args, snip)
	local rows = tonumber(snip.captures[1])
	local cols = tonumber(snip.captures[2])
	local nodes = {}
	local ins_indx = 1
	local indent = "\t\t"

	table.insert(nodes, t("\\hline"))
	table.insert(nodes, t({"", ""}))

	for j = 1, rows do
		table.insert(nodes, t(indent))
		table.insert(nodes, r(ins_indx, tostring(j) .. "x1", i(1)))
		ins_indx = ins_indx + 1
		for k = 2, cols do
			table.insert(nodes, t(" & "))
			table.insert(nodes, r(ins_indx, tostring(j) .. "x" .. tostring(k), i(1)))
			ins_indx = ins_indx + 1
		end
		table.insert(nodes, t({ " \\\\" }))
		table.insert(nodes, t({"", ""}))
		table.insert(nodes, t({ indent .. "\\hline"}))
		table.insert(nodes, t({"", ""}))
	end
	-- fix last node.
	-- nodes[#nodes] = t("\\\\")
	return sn(nil, nodes)
end

return {

-----------------
-- ENVIRONMENT --
-----------------

-- displaystyle
s({trig="ds", snippetType="snippet", desc="Display style"},
	fmta(
		[[
			\displaystyle{<>}
		]],
		{visual_body(1)}
	)
),

-- quad
s({trig="q", snippetType="snippet", desc="quad spacing",wordTrig=false},
	{t("\\quad"),}
),

-- qquad
s({trig="qq", snippetType="snippet", desc="qquad spacing",wordTrig=false},
	{t("\\qquad"),}
),

-- Lemma
s({trig="lemma", snippetType="snippet", desc="Lemma environment"},
	fmta(
		[[
			\lemma{<>}{<>}
		]],
		{i(1),i(2)}
	)
),

-- Proposition environment
s({ trig = "prop", snippetType = "snippet", desc = "Proposition environment" },
	fmta(
		[[
			\begin{prop}[<>]
				<>
			\end{prop}
		]],
		{i(1), visual_body(2)}
	)
),

-- Theorem
s({trig="thrm", snippetType="snippet", desc="Theorem environment"},
	fmta(
		[[
			\thm{<>}{<>}
		]],
		{i(1),i(2)}
	)
),

-- Question
s({trig="qs", snippetType="snippet", desc="Question"},
	fmta(
		[[
			\qs{<>}{<>}
		]],
		{i(1),i(2)}
	)
),

-- Postulate environment
s({ trig = "post", snippetType = "snippet", desc = "Postulate environment" },
	fmta(
		[[
			\begin{postulate}[<>]
				<>
			\end{postulate}
		]],
		{i(1), visual_body(2)}
	)
),

-- Proof environment
s({ trig = "prf", snippetType = "snippet", desc = "Proof environment" },
	fmta(
		[[
			\begin{proof}[Proof]
				<>
			\end{proof}
		]],
		{
		f(function(_, snip)
			local sel = snip.env.LS_SELECT_RAW
			if not sel or sel == "" then 
				return i(1)
			end
          
			-- normalize selection to a string
			local lines = type(sel) == "table" and sel or { sel }
			return table.concat(lines, "\n")
		end)
		}
	)
),

-- Note
s({ trig = "nte", snippetType = "snippet", desc = "Note environment" },
	fmta(
		[[
			\begin{note}[<>]
				<>
			\end{note}
		]],
		{i(1), visual_body(2)}
	)
),

-- Problem
s({ trig = "prob", snippetType = "snippet", desc = "Problem environment" },
	fmta(
		[[
			\begin{problem}[<>]
				<>
			\end{problem}
		]],
		{i(1), visual_body(2)}
	)
),

-- Corollary
s({ trig = "corl", snippetType = "snippet", desc = "Corollary environment" },
	fmta(
		[[
			\begin{corollary}[<>]
				<>
			\end{corollary}
		]],
		{i(1), visual_body(2)}
	)
),

-- Example
s({ trig = "example", snippetType = "snippet", desc = "Example environment" },
	fmta(
		[[
			\begin{example}[<>]
				<>
			\end{example}
		]],
		{i(1), visual_body(2)}
	)
),

-- Notation
s({ trig = "notion", snippetType = "snippet", desc = "Notation environment" },
	fmta(
		[[
			\begin{notation}[<>]
				<>
			\end{notation}
		]],
		{i(1), visual_body(2)}
	)
),

-- Conclusion
s({ trig = "conc", snippetType = "snippet", desc = "Conclusion environment" },
	fmta(
		[[
			\begin{conclusion}[<>]
				<>
			\end{conclusion}
		]],
		{i(1), visual_body(2)}
	)
),

-- Itemize
s({ trig = "item", snippetType = "snippet", desc = "itemize" },
	fmta(
		[[
			\begin{itemize}[label=\(\circ\)]
				\item <>
				\item <>
			\end{itemize}
		]],
		{i(1), i(2)}
	)
),

-- Enumerate
s({ trig = "enum", snippetType = "snippet", desc = "enumerate" },
	fmta(
		[[
			\begin{enumerate}[label=(\alph*)]
				\item <>
				\item <>
			\end{enumerate}
		]],
		{i(1), i(2)}
	)
),

-- Align
s({ trig = "ali", snippetType = "snippet", desc = "align" },
	fmta(
		[[
			\begin{align*}
				<> & <> \\[12pt]
				<> & <> \\ <>
			\end{align*}
		]],
		{i(1), i(2), i(3), i(4), i(5)}
	)
),

-- Align At
s({ trig = "aliat", snippetType = "snippet", desc = "align at" },
	fmta(
		[[
			\begin{alignat*}{<>}
				<> && <> & <> \\
				<> && <> & <> \\ <>
			\end{alignat*}
		]],
		{i(1), i(2), i(3), i(4), i(5), i(6), i(7), i(8)}
	)
),

-- Figure
s("fig", 
	fmta(
		[[
			\begin{figure}[<>]
  				\centering
  				\includegraphics[width=0.8\textwidth]{<>}
				\caption{<>}
  				\label{fig:<>}
			\end{figure}
  		]], 
		{
		i(1, "htpb"), 
    		i(2),
    		i(3),
    		f(function(args)
			local text = args[1][1] or ""
      			return text:gsub("%W+", "-")
    		end, {3}),
  		}
	)
),

-- Abstract
s({ trig = "abst", snippetType = "snippet", desc = "Abstract environment" },
	fmta(
		[[
			\begin{abstract}
				<>
			\end{abstract}
		]],
		{visual_body(1)}
	)
),

-- Table 
s({trig = "tabl(%d+)x(%d+)", snippetType="autosnippet", regTrig = true, wordTrig=false, dscr = "Table of A x B size"},
	fmta(
		[[
			\begin{center}
				\begin{tabular}{<>}
					<>
				\end{tabular}
			\end{center}
		]],
		{i(1),d(2, generate_table)}
	)
),

-- Matrix
s({trig = "([%sbBpvV])mat(%d+)x(%d+)", snippetType="autosnippet", regTrig = true, wordTrig=false, dscr = "[bBpvV]matrix of A x B size"},
	fmta(
		[[
    			\begin{<>}
    				<>
    			\end{<>}
		]],
    		{
		f(function(_, snip)
        		if  snip.captures[1] ==" " then
        			return "matrix"
        		else
        	    		return snip.captures[1] .. "matrix"
       			end
    		end),
    		d(1, generate_matrix),
    		f(function(_, snip)
    		    return snip.captures[1] .. "matrix"
    		end)
    		}
	),
	{ show_condition=math }
),

-- Center 
s({trig="cen", snippetType="snippet", desc="Center environment"},
	fmta(
		[[
			\begin{center}
				<>
			\end{center}
		]],
		{visual_body(1)}
	)
),

-- Graphics
s({trig="pix", snippetType="snippet", desc="Graphics environment"},
	fmta(
		[[
			\includegraphics[width=1.0\textwidth]{<>}
		]],
		{i(1)}
	)
),

-- Cases
s({trig="cases", snippetType="snippet", desc="Cases environment"},
	fmta(
		[[
			\begin{cases}
				<> & <> \\
				<> & <> \\
			\end{cases}
		]],
		{i(1),i(2),i(3),i(4)}
	)
),

----------
-- TEXT --
----------

-- Text
s({trig="txt", snippetType="snippet", desc="text"},
	fmta(	
		[[
			\text{<>}
		]],
		{visual_body(1)}
	)
),
-- visual_body(i) includes highlighted text (in visual mode) into the snippet. But we should have an option for triggering 'txt' and directly writing in text.
--
-- To activate: visual select (highlight) the text, press <TAB>, and then type the trigger

-- Boldface
s({trig="bf", snippetType="snippet", desc="boldface"},
	fmta(	
		[[
			\textbf{<>}
		]],
		{visual_body(1)}
	)
),

-- Poor Man's Bold
s({trig="pmb", snippetType="snippet", desc="Poor Man's Bold"},
	fmta(	
		[[
			\pmb{<>}
		]],
		{visual_body(1)}
	)
),

-- Italics
s({trig="it", snippetType="snippet", desc="Italics"},
	fmta(	
		[[
			\textit{<>}
		]],
		{visual_body(1)}
	)
),

-- Verbatim
s({trig="verb", snippetType="snippet", desc="Verbatim"},
	fmta(	
		[[
			\begin{verbatim}
			<>
			\end{verbatim}
		]],
		{i(1)}
	)
),

-- Underline
s({trig="ul", snippetType="snippet", desc="Underline"},
	fmta(	
		[[
			\underline{<>}
		]],
		{visual_body(1)}
	)
),

-- Boxed
s({trig="box", snippetType="snippet", desc="Boxed"},
	fmta(	
		[[
			\boxed{<>}
		]],
		{visual_body(1)}
	)
),

-- Vspace
s({trig="vs", snippetType="autosnippet", desc="vspace",wordTrig=false},
	{t("\\vspace{12pt}")}
),

-- Underbrace
s({trig="ub", snippetType="snippet", desc="Underbrace"},
	fmta(	
		[[
			\underbrace{<>}_{<>}
		]],
		{i(1), i(2)}
	)
),

-- Overbrace
s({trig="ob", snippetType="snippet", desc="Overbrace"},
	fmta(	
		[[
			\overbrace{<>}_{<>}
		]],
		{i(1), i(2)}
	)
),

----------
-- CODE -- 
----------

-- Code
s({trig="code", snippetType="snippet", desc="Inline code"},
	fmta(	
		[[
			\lstinline{<>}
		]],
		{visual_body(1)}
	)
),

-- Code Block
s({trig="codebk", snippetType="snippet", desc="Code block"},
	fmta(	
		[[
			\begin{lstlisting}
			<>
			\end{lstlisting}
		]],
		{i(1)}
	)
),

----------------------
-- LETTER MODIFIERS --
----------------------

--postfixes for vectors, hats, etc. The match pattern is '\\' plus the default (so that hats get put on greek letters,e.g.)
postfix({trig="hat", match_pattern = [[[\\%w%.%_%-%"%']+$]], snippetType="autosnippet",dscr="postfix hat when in math mode"},
	{l("\\hat{" .. l.POSTFIX_MATCH .. "}")}, 
	{ condition=math }
),

----------------
-- DELIMITERS --
----------------

-- Parentheses
s({trig="parens", snippetType="snippet", desc="Parentheses"},
	fmta(	
		[[
			\!\left( <> \right)
		]],
		{i(1)}
	)
),

-- Brackets
s({trig="bra", snippetType="snippet", desc="Brackets"},
	fmta(	
		[[
			\!\left[ <> \right]
		]],
		{i(1)}
	)
),

-- Squiggly Brackets
s({trig="squig", snippetType="snippet", desc="Squiggly Brackets"},
	fmta(	
		[[
			\!\left\{ <> \right\}
		]],
		{i(1)}
	)
),

-- Big Bar
s({trig="bigbar", snippetType="snippet", desc="Big Vertical Bar"},
	fmta(	
		[[
			\!\| <> \|
		]],
		{i(1)}
	)
),

--------------
-- GEOMETRY --
--------------

s({trig="deg", snippetType="snippet", desc="Degree",wordTrig=false},
    {t("\\circ"),}
),

----------
-- MATH --
----------

-- Plus Minus
s({trig="pm", snippetType="snippet", desc="plus minus",wordTrig=false},
    {t("\\pm"),}
),

-- Set Builder Notation
s({trig="set", snippetType="snippet", desc="Set Builder Notation"},
	fmta(	
		[[
			\left\{\, <> \mid <> \, \right\}
		]],
		{i(1),i(2)}
	)
),

-- Subset
s({trig="cc", snippetType="snippet", desc="Subset",wordTrig=false},
    {t("\\subset"),}
),

-- Reverse Subset
s({trig="ncc", snippetType="snippet", desc="Reverse Subset",wordTrig=false},
    {t("\\supset"),}
),

-- Empty Set 
s({trig="emp", snippetType="snippet", desc="Empty Set",wordTrig=false},
    {t("\\varnothing"),}
),

-- Set Membership 
s({trig="inn", snippetType="snippet", desc="Set Membership",wordTrig=false},
    {t("\\in"),}
),

-- Set Non-membership 
s({trig="ninn", snippetType="snippet", desc="Set Non-Membership",wordTrig=false},
    {t("\\not\\in"),}
),

-- Intersection 
s({trig="Nn", snippetType="snippet", desc="cap",wordTrig=false},
    {t("\\cap"),}
),

-- Union
s({trig="UU", snippetType="snippet", desc="cup",wordTrig=false},
    {t("\\cup"),}
),

-- Big Union
s({trig="uuu", snippetType="snippet", desc="Big Union"},
	fmta(	
		[[
			\bigcup_{<1> \in <2>}
		]],
		{i(1),i(2)}
	)
),

-- Big Intersection
s({trig="nnn", snippetType="snippet", desc="Big Intersection"},
	fmta(	
		[[
			\bigcap_{<1> \in <2>}
		]],
		{i(1),i(2)}
	)
),

-- H
s({trig="HH", snippetType="snippet", desc="H",wordTrig=false}, 
	{t("\\mathbb{H}"),}
),

-- D
s({trig="DD", snippetType="snippet", desc="D",wordTrig=false}, 
	{t("\\mathbb{D}"),}
),

-- Inline Math
s({trig="math", snippetType="snippet", desc="Inline Math"}, 
	fmta(
		[[
			\( <> \)
		]],
		{i(1)}
	)
),

-- Display Math
s({trig="dm", snippetType="snippet", desc="Display Math"}, 
	fmta(
		[[
			\[
				<> 
			\]
		]],
		{i(1)}
	)
),

-- Fraction
s({trig="frac", snippetType="snippet", desc="fraction"}, 
	fmta(
		[[
			\frac{<>}{<>}
		]],
		{i(1),i(2)}
	)
),

-- Inline Fraction 
s({trig="infrac", snippetType="snippet", desc="Inline fraction"}, 
	fmta(
		[[
			\dfrac{<>}{<>}
		]],
		{i(1),i(2)}
	)
),

-- Complement
s({trig="compl", snippetType="snippet", desc="Complement",wordTrig=false}, 
	{t("^{c}"),}
),

-- Superscript
s({trig=";ss", snippetType="autosnippet", desc="Superscript", wordTrig=false}, 
	fmta(
		[[
			^{<>}
		]],
		{i(1)}
	)
),

-- Subscript
s({trig=";sb", snippetType="autosnippet", desc="Subscript", wordTrig=false}, 
	fmta(
		[[
			_{<>}
		]],
		{i(1)}
	)
),

-- Square Root
s({trig="srt", snippetType="snippet", desc="Square Root"}, 
	fmta(
		[[
			\sqrt{<>}
		]],
		{i(1)}
	)
),

-- nth Root
s({trig="srto", snippetType="snippet", desc="nthRoot"}, 
	fmta(
		[[
			\sqrt[<>]{<>}
		]],
		{i(1),i(2)}
	)
),

-- Ceiling 
s({trig="ceil", snippetType="snippet", desc="Ceiling"}, 
	fmta(
		[[
			\left\lceil <> \right\rceil
		]],
		{i(1)}
	)
),

-- Floor
s({trig="floor", snippetType="snippet", desc="Floor"}, 
	fmta(
		[[
			\left\lfloor <> \right\rfloor
		]],
		{i(1)}
	)
),

-- Absolute Value
s({trig="abs", snippetType="snippet", desc="Absolute Value"}, 
	fmta(
		[[
			\abs{<>}
		]],
		{i(1)}
	)
),

-- Conjugate
s({trig="conj", snippetType="snippet", desc="Conjugate"}, 
	fmta(
		[[
			\overline{<>}
		]],
		{i(1)}
	)
),

-- Sum
s({trig="sum", snippetType="snippet", desc="Sum"}, 
	fmta(
		[[
			\sum_{<>}^{<>} <>
		]],
		{i(1),i(2),i(3)}
	)
),

-- Limit
s({trig="lim", snippetType="snippet", desc="Limit"}, 
	fmta(
		[[
			\lim\limits_{<> \to <>}
		]],
		{i(1),i(2)}
	)
),

-- Limit Supremum
s({trig="limsup", snippetType="snippet", desc="Limit Supremum"}, 
	fmta(
		[[
			\limsup_{<> \to <>}
		]],
		{i(1),i(2)}
	)
),

-- Product
s({trig="prod", snippetType="snippet", desc="Product"}, 
	fmta(
		[[
			\prod_{<>}^{<>} <>
		]],
		{i(1),i(2),i(3)}
	)
),

-- Infinity
s({trig="ooo", snippetType="snippet", desc="Infinity",wordTrig=false},
    {t("\\infty"),}
),

-- Implies
s({trig="imp", snippetType="snippet", desc="Implies",wordTrig=false},
    {t("\\implies"),}
),

-- Implied by 
s({trig="=<", snippetType="snippet", desc="Implied By",wordTrig=false},
    {t("\\impliedby"),}
),

-- iff 
s({trig="iff", snippetType="snippet", desc="iff",wordTrig=false},
    {t("\\iff"),}
),

-- Equals (align)
s({trig="==", snippetType="snippet", desc="Equals (align)"},
	fmta(
		[[
			&= <> \\
		]],
		{i(1)}
	)
),

-- Not Equal
s({trig="neq", snippetType="snippet", desc="Not Equal",wordTrig=false},
    {t("\\neq"),}
),

-- Less Than or Equal To
s({trig="le", snippetType="snippet", desc="Less Than or Equal To",wordTrig=false},
    {t("\\le"),}
),

-- Greater Than or Equal To
s({trig="ge", snippetType="snippet", desc="Greater Than or Equal To",wordTrig=false},
    {t("\\ge"),}
),

-- Curly l
s({trig="lll", snippetType="snippet", desc="Curly l",wordTrig=false},
    {t("\\ell"),}
),

-- Cross 
s({trig="xx", snippetType="snippet", desc="Cross",wordTrig=false},
    {t("\\times"),}
),

-- sin
s({trig="sin", snippetType="snippet", desc="sine",wordTrig=false},
    c(1,
    	{
    	sn(nil, fmta([[ \sin\!\left(<>\right) ]],{i(1)})),
	sn(nil, fmta([[ \sin^{<>}\!\left(<>\right) ]],{i(1),i(2)}))
	}
    )
),

-- cos 
s({trig="cos", snippetType="snippet", desc="cosine",wordTrig=false},
    c(1,
    	{
    	sn(nil, fmta([[ \cos\!\left(<>\right) ]],{i(1)})),
	sn(nil, fmta([[ \cos^{<>}\!\left(<>\right) ]],{i(1),i(2)}))
	}
    )
),

-- tan
s({trig="tan", snippetType="snippet", desc="tangent",wordTrig=false},
    c(1,
    	{
    	sn(nil, fmta([[ \tan\!\left(<>\right) ]],{i(1)})),
	sn(nil, fmta([[ \tan^{<>}\!\left(<>\right) ]],{i(1),i(2)}))
	}
    )
),

-- ln
s({trig="ln", snippetType="snippet", desc="natural logarithm",wordTrig=false},
    	fmta(
		[[ 
			\ln\!\left(<>\right) 
		]],
	{i(1)})
),

-- Maps To
s({trig="!>", snippetType="snippet", desc="Maps to",wordTrig=false},
    {t("\\mapsto"),}
),

-- Sim 
s({trig="sim", snippetType="snippet", desc="Sim",wordTrig=false},
    {t("\\sim"),}
),

-- Approx
s({trig="approx", snippetType="snippet", desc="Approximately",wordTrig=false},
    {t("\\approx"),}
),

-- Vbar
s({trig="vbar", snippetType="snippet", desc="|",wordTrig=false},
    {t("\\mid"),}
),

-- Norm
s({trig="norm", snippetType="snippet", desc="||"},
	fmta(
		[[
			\norm{<>}
		]],
		{i(1)}
	)
),

----------
-- DOTS --
----------

-- DOTS
s({trig="dots", snippetType="snippet", desc="Dots",wordTrig=false},
    {t("\\dots"),}
),

-- CDOT
s({trig="cdot", snippetType="snippet", desc="CDOT",wordTrig=false},
    {t("\\cdot"),}
),

-- CDOTS
s({trig="cdots", snippetType="snippet", desc="CDOTS",wordTrig=false},
    {t("\\cdots"),}
),

-- VDOTS
s({trig="vdots", snippetType="snippet", desc="VDOTS",wordTrig=false},
    {t("\\vdots"),}
),

-- LDOTS
s({trig="ldots", snippetType="snippet", desc="LDOTS",wordTrig=false},
    {t("\\ldots"),}
),

--------------
-- CALCULUS --
--------------

-- Derivative
s({trig="dd", snippetType="snippet", desc="Derivative"},
	fmta(
		[[
			\frac{d <>}{d <>}
		]],
		{i(1),i(2)}
	)
),

-- Partial Derivative
s({trig="part", snippetType="snippet", desc="Partial Derivative"},
	fmta(
		[[
			\frac{\partial <>}{\partial <>}
		]],
		{i(1),i(2)}
	)
),

-- Integration
-- Use as example for choice snippet
s({trig="int", snippetType="snippet", desc="Integral"},
			c(1,
				{
				sn(nil, fmta([[ \int_{-\infty}^{\infty} <> \, d<> ]],{i(1),i(2)})),
				sn(nil, fmta([[ \int_{<>}^{<>} <> \, d<> ]],{i(1),i(2),i(3),i(4)}))
				}
			)
),

-- Integration bounds
s({trig="intb", snippetType="snippet", desc="Integral bounds"},
	fmta(
		[[
			\Big|^{<>}_{<>}
		]],
		{i(1),i(2)}
	)
),

-- Gradient
s({trig="grad", snippetType="snippet", desc="Gradient",wordTrig=false},
    {t("\\nabla"),}
),

--------------------
-- MATRIX ALGEBRA --
--------------------

-- Matrix Inverse
s({trig="minv", snippetType="snippet", desc="Matrix Inverse",wordTrig=false},
    {t("\\alpha"),}
),

-- Matrix Transpose
s({trig="tr", snippetType="snippet", desc="Matrix Transverse",wordTrig=false},
    {t("^{\\textsc{T}}"),}
),


-----------------------
-- SPECIAL FUNCTIONS --
-----------------------

-- Min
s({trig="min", snippetType="snippet", desc="Min",wordTrig=false},
	fmta(
		[[
			\min\{ <> \}
		]],
		{i(1)}
	)
),

-- Max
s({trig="max", snippetType="snippet", desc="Max",wordTrig=false},
	fmta(
		[[
			\max\{ <> \}
		]],
		{i(1)}
	)
),

------------
-- ARROWS --
------------

-- Up Arrow 
s({trig="up", snippetType="snippet", desc="Up Arrow",wordTrig=false},
    {t("\\uparrow"),}
),

-- Down Arrow 
s({trig="down", snippetType="snippet", desc="Down Arrow",wordTrig=false},
    {t("\\downarrow"),}
),

-- Left Arrow 
s({trig="left", snippetType="snippet", desc="Left Arrow",wordTrig=false},
    {t("\\leftarrow"),}
),

-- Right Arrow 
s({trig="right", snippetType="snippet", desc="Right Arrow",wordTrig=false},
    {t("\\rightarrow"),}
),

-- Left Arrow Text
s({trig="xleft", snippetType="snippet", desc="Left Arrow Text",wordTrig=false},
	fmta(
		[[
			\xleftarrow{\text{<>}}
		]],
		{i(1)}
	)
),

-- Right Arrow Text
s({trig="xright", snippetType="snippet", desc="Right Arrow Text",wordTrig=false},
	fmta(
		[[
			\xrightarrow{\text{<>}}
		]],
		{i(1)}
	)
),


---------------------
-- COMPLEX NUMBERS --
---------------------

-- Real
s({trig="Re", snippetType="snippet", desc="Real Number",wordTrig=false},
    {t("\\Real"),}
),

-- Imaginary
s({trig="Im", snippetType="snippet", desc="Imaginary Number",wordTrig=false},
    {t("\\Imag"),}
),

-----------------
-- PROBABILITY --
-----------------

-- Probability
s({trig="prb", snippetType="snippet", desc="Probability",wordTrig=false},
	fmta(
		[[
			\Prob\left( <> \right)
		]],
		{i(1)}
	)
),

-- Variance
s({trig="var", snippetType="snippet", desc="Variance",wordTrig=false},
	fmta(
		[[
			\var\left( <> \right)
		]],
		{i(1)}
	)
),

-- Expectation
s({trig="expt", snippetType="snippet", desc="Expectation",wordTrig=false},
	fmta(
		[[
			\E\left( <> \right)
		]],
		{i(1)}
	)
),

-- Standard Deviation
s({trig="sd", snippetType="snippet", desc="Standard Deviation",wordTrig=false},
	fmta(
		[[
			\sd\left( <> \right)
		]],
		{i(1)}
	)
),

-- Probability Density Function 
s({trig="pdf", snippetType="snippet", desc="pdf",wordTrig=false},
	fmta(
		[[
			f_{<>}\left( <> \right)
		]],
		{i(1),i(2)}
	)
),

-- Cumulative Density Function 
s({trig="cdf", snippetType="snippet", desc="cdf",wordTrig=false},
	fmta(
		[[
			F_{<>}\left( <> \right)
		]],
		{i(1),i(2)}
	)
),

-- Independence
s({trig="ind", snippetType="snippet", desc="Independence",wordTrig=false},
    {t("\\sqcup"),}
),

-- Bernoulli 
s({trig="bern", snippetType="snippet", desc="Bernoulli",wordTrig=false},
	fmta(
		[[
			\Bernoulli\left( <> \right)
		]],
		{i(1)}
	)
),

-- Beta
s({trig="betaD", snippetType="snippet", desc="Beta Distribution",wordTrig=false},
	fmta(
		[[
			\betaD\left( <> \right)
		]],
		{i(1)}
	)
),

-- Bias
s({trig="bias", snippetType="snippet", desc="bias",wordTrig=false},
    {t("\\bias"),}
),

-- Binomial
s({trig="bi", snippetType="snippet", desc="Binomial Distribution",wordTrig=false},
	fmta(
		[[
			\binomial\left( <> \right)
		]],
		{i(1)}
	)
),

-- Correlation 
s({trig="corr", snippetType="snippet", desc="Correlation",wordTrig=false},
	fmta(
		[[
			\corr\left( <> \right)
		]],
		{i(1)}
	)
),

-- Covariance
s({trig="cov", snippetType="snippet", desc="cov",wordTrig=false},
	fmta(
		[[
			\cov\left( <> \right)
		]],
		{i(1)}
	)
),

-- Exponential
s({trig="Exp", snippetType="snippet", desc="Exponential",wordTrig=false},
	fmta(
		[[
			\Exp\left( <> \right)
		]],
		{i(1)}
	)
),

-- Gamma
s({trig="gammaD", snippetType="snippet", desc="Gamma",wordTrig=false},
	fmta(
		[[
			\gammaD\left( <> \right)
		]],
		{i(1)}
	)
),

-- MSE
s({trig="mse", snippetType="snippet", desc="MSE",wordTrig=false},
    {t("\\mse"),}
),

-- Multimonial
s({trig="multi", snippetType="snippet", desc="Multimonial",wordTrig=false},
	fmta(
		[[
			\multimonial\left( <> \right)
		]],
		{i(1)}
	)
),

-- Poisson
s({trig="poi", snippetType="snippet", desc="Poisson",wordTrig=false},
	fmta(
		[[
			\Poisson\left( <> \right)
		]],
		{i(1)}
	)
),

-- Standard Error
s({trig="se", snippetType="snippet", desc="Standard Error",wordTrig=false},
    {t("\\se"),}
),

-- Uniform
s({trig="uni", snippetType="snippet", desc="Uniform",wordTrig=false},
	fmta(
		[[
			\Uniform\left( <> \right)
		]],
		{i(1)}
	)
),

-----------
-- GREEK --
-----------

s({trig="alp", snippetType="snippet", desc="alpha",wordTrig=false},
    {t("\\alpha"),}
),

s({trig="beta", snippetType="snippet", desc="beta",wordTrig=false},
    {t("\\beta"),}
),

s({trig="delta", snippetType="snippet", desc="delta",wordTrig=false},
    {t("\\delta"),}
),

s({trig="Delta", snippetType="snippet", desc="Delta",wordTrig=false},
    {t("\\Delta"),}
),

s({trig="gamma", snippetType="snippet", desc="gamma",wordTrig=false},
    {t("\\gamma"),}
),

s({trig="Gamma", snippetType="snippet", desc="Gamma",wordTrig=false},
    {t("\\Gamma"),}
),

s({trig="eps", snippetType="snippet", desc="epsilon",wordTrig=false},
    {t("\\epsilon"),}
),

s({trig="mu", snippetType="snippet", desc="mu",wordTrig=false},
    {t("\\mu"),}
),

s({trig="om", snippetType="snippet", desc="omega",wordTrig=false},
    {t("\\omega"),}
),

s({trig="Om", snippetType="snippet", desc="Omega",wordTrig=false},
    {t("\\Omega"),}
),

s({trig="lam", snippetType="snippet", desc="lambda",wordTrig=false},
    {t("\\lambda"),}
),

s({trig="Lam", snippetType="snippet", desc="Lambda",wordTrig=false},
    {t("\\Lambda"),}
),

s({trig="pi", snippetType="snippet", desc="pi",wordTrig=false},
    {t("\\pi"),}
),

s({trig="phi", snippetType="snippet", desc="phi",wordTrig=false},
    {t("\\phi"),}
),

s({trig="Phi", snippetType="snippet", desc="Phi",wordTrig=false},
    {t("\\Phi"),}
),

s({trig="psi", snippetType="snippet", desc="psi",wordTrig=false},
    {t("\\psi"),}
),

s({trig="rho", snippetType="snippet", desc="rho",wordTrig=false},
    {t("\\rho"),}
),

s({trig="sig", snippetType="snippet", desc="sigma",wordTrig=false},
    {t("\\sigma"),}
),

s({trig="Sig", snippetType="snippet", desc="Sigma",wordTrig=false},
    {t("\\Sigma"),}
),

s({trig="tau", snippetType="snippet", desc="tau",wordTrig=false},
    {t("\\tau"),}
),

s({trig="theta", snippetType="snippet", desc="theta",wordTrig=false},
    {t("\\theta"),}
),

---------------
-- PRE-AMBLE --
---------------

-- Document Class
s({trig="docls", snippetType="snippet", desc="Document Class",wordTrig=false},
	fmta(
		[[
			\documentclass\left( <> \right)
		]],
		{i(1)}
	)
),

-- New Command 
s({trig="newc", snippetType="snippet", desc="New Command",wordTrig=false},
	fmta(
		[[
			\newcommand\left( <> \right)
		]],
		{i(1)}
	)
),

-- Declare Math Operator
s({trig="decl", snippetType="snippet", desc="Declare Math Operator",wordTrig=false},
	fmta(
		[[
			\DeclareMathOperator\left( <> \right)
		]],
		{i(1)}
	)
),

------------
-- BEAMER --
------------

-- Frame 
s({trig="fr", snippetType="snippet", desc="Frame",wordTrig=false},
	fmta(
		[[
			\begin{frame}
				<>
			\end{frame}
		]],
		{visual_body(1)}
	)
),

-- Frame Title 
s({trig="frt", snippetType="snippet", desc="Frame Title",wordTrig=false},
	fmta(
		[[
			\frametitle\left( <> \right)
		]],
		{i(1)}
	)
),

}
