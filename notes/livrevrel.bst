%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This is file livrevrel.bst, the bibtex style for the electronic
% journal Living Reviews in Relativity
% (http://relativity.livingreviews.org). The style should work for the
% reference genres specified in the livrev reference database import
% schema http://dev.livingreviews.org/epubtk/refdb/import_doc.html
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% from utphys.bst modifications by Jacques Distler:
%
% HyperTeX Wizardry:
%
% The following are equivalent:
%   archive  =  arXiv
%   eprint   = "hep-th/9605023"
% and
%   eprint   = "hep-th/9605023"
% both produce 
%
%    \href{http://arxiv.org/abs/hep-th/9605023}{{\tt hep-th/9605023}}
%
% in the bibliographic output at the appropriate point. More generally,
% if the archive field is present, we produce a URL of the form
% "archive/eprint" as the first argument of the \href. If absent, the base
% URL defaults to "http://arxiv.org/abs"
% If you are using a hypertex macropackage, like hyperref.sty, this command
% will create a link to the eprint at Los Alamos (or wherever).
%
% "New-style" arXiv identifiers are also supported.
%
%     archivePrefix = "arXiv",
%     eprint    = "0707.3168",
%     primaryClass = "hep-th",
%
% produces
%
%     \href{http://arxiv.org/abs/0707.3168}{{\tt arXiv:0707.3168 [hep-th]}}
%
% Another (non-arXiv) example:
%
%     archive = "http://cogprints.org",
%     eprint = "5542",
%     archivePrefix = "Cogprints",
%
%  produces
%
%     \href{http://cogprints.org/5542}{{\tt Cogprints:5542}}
%
% The bibtex output produced by SPIRES, while far from perfect, is pretty
% suitable for use with this style. Indeed, this style was designed with
% SPIRES in mind.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ENTRY
  { address
    adsurl
    archive
    archivePrefix
    ark
    author
    booktitle
    cited
    chapter
    collaboration
    conference
    day
    doi
    edition
    editor
    eid
    eprint
    format
    gbs_id
    journal
    key
    keywords
    month
    note
    newspaper
    number
    onlineversion
    organization
    pages
    primaryClass
    publisher
    school
    series
    title
    type
    url
    volume
    year
  }
  {}
  { label }

INTEGERS { output.state before.all mid.sentence after.sentence after.block }

FUNCTION {init.state.consts}
{ #0 'before.all :=
  #1 'mid.sentence :=
  #2 'after.sentence :=
  #3 'after.block :=
}

STRINGS { s t }

FUNCTION {output.nonnull}
{ 's :=
  output.state mid.sentence =
    { ", " * write$ }
    { output.state after.block =
    	{ add.period$ write$
      	  newline$
      	  "\newblock " write$
    	}
    	{ output.state before.all =
            'write$
            { add.period$ " " * write$ }
          if$
        }
      if$
      mid.sentence 'output.state :=
    }
  if$
  s
}

FUNCTION {output}
{ duplicate$ empty$
    { pop$ }
    'output.nonnull
  if$
}

FUNCTION {output.check}
{ 't :=
  duplicate$ empty$
    { pop$ "empty " t * " in " * cite$ * warning$ }
    'output.nonnull
  if$
}

FUNCTION {output.bibitem}
{ newline$
  "\bibitem{" write$
  cite$ write$
  "}" write$
  before.all 'output.state :=
}

FUNCTION {fin.entry}
{ add.period$
  write$
  newline$
}

FUNCTION {new.block}
{ output.state before.all =
    { skip$ }
    { after.block 'output.state := }
  if$
}

FUNCTION {new.sentence}
{ output.state after.block =
    { skip$ }
    { output.state before.all =
    	{ skip$ }
    	{ after.sentence 'output.state := }
      if$
    }
  if$
}

FUNCTION {add.blank}
{  " " * before.all 'output.state :=
}

FUNCTION {not}
{   { #0 }
    { #1 }
  if$
}

FUNCTION {and}
{   { skip$ }
    { pop$ #0 }
  if$
}

FUNCTION {or}
{   { pop$ #1 }
    { skip$ }
  if$
}

FUNCTION {new.block.checka}
{ empty$
    { skip$ }
    'new.block
  if$
}

FUNCTION {new.block.checkb}
{ empty$
  swap$ empty$
  and
    { skip$ }
    'new.block
  if$
}

FUNCTION {new.sentence.checka}
{ empty$
    { skip$ }
    'new.sentence
  if$
}

FUNCTION {new.sentence.checkb}
{ empty$
  swap$ empty$
  and
    { skip$ }
    'new.sentence
  if$
}

FUNCTION {field.or.null}
{ duplicate$ empty$
    { pop$ "" }
    { skip$ }
  if$
}

FUNCTION {emphasize}
{ duplicate$ empty$
    { pop$ "" }
    { "{\em " swap$ * "}" * }
  if$
}

FUNCTION {bold}
{ duplicate$ empty$
    { pop$ "" }
    { "{\bf " swap$ * "}" * }
  if$
}

FUNCTION {format.collaboration}
{ collaboration empty$
    { "" }
    { collaboration num.names$ #1 >
        {" (" collaboration * ")" * } %" Collaborations)"
        {" (" collaboration * ")" * } %" Collaboration)"
    if$
    }
  if$
}

INTEGERS { nameptr namesleft numnames }

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Nifty function that formats names correctly, taking out      %
% all those nasty things we don't like, and adding nice things %
% like et~al.                                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FUNCTION {format.names}
{ 's :=
  #1 'nameptr :=
  s num.names$ 'numnames :=
  numnames 'namesleft :=
%% AA 3/19/2009
%% This fix courtesy of Craig Wiegert <wigie@alum.mit.edu>
%% and comes by way of Tim Robishaw; a similar patch has
%% also been contributed by Andy Marble <amarble@as.arizona.edu>
%% Added the following two lines to make 8 author upper limit to
%% reference list, based on what is found in aas.bst.
  numnames #8 >
    { s #1 "{vv~}{ll}{, jj}{, ff}" format.name$ " {et~al.}" * }
    { { namesleft #0 > }
      { s nameptr
	"{vv~}{ll}{, jj}{, ff}" format.name$
	't :=
	nameptr #1 >
	  {
            namesleft #1 >
              { ", " * t * }
              {
                  numnames #1 >
                  { " " * }
                  'skip$
                if$
                s nameptr "{ll}" format.name$ duplicate$ "others" =
                  { 't := }
                  { pop$ }
                if$
                t "others" =
                  {
                    " {et~al.}" *
                  }
                  { " and " * t * }
                if$
              }
            if$
          }
          't
        if$
        nameptr #1 + 'nameptr :=
        namesleft #1 - 'namesleft :=
      }
    while$
    }
  if$
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Functions to output thesis formats                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

FUNCTION {bbl.mthesis}
{ "Master's thesis" }

FUNCTION {bbl.phdthesis}
{ "Ph.D. thesis" }

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Functions to output format for 'misc' and 'online'           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

FUNCTION {bbl.unknown.format}
{ "unknown format" 
}

FUNCTION {bbl.default.format}
{ "" format * 
}

FUNCTION {bbl.other.format}
{ "online resource" 
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Functions to output format for 'unpublished'                 %
% nb: field 'format' provides statusinfo in genre 'unpublished'%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

FUNCTION {bbl.unknown.status}
{ "unpublished" 
}

FUNCTION {bbl.default.status}
{ "" format * 
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to format series and number (for tech rep)          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

FUNCTION {format.tr.series}
{ number empty$
    { "" }
    { series empty$
        'skip$
        { ", " * series * }
      if$
      number
    }
  if$
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to format the publisher (for online)                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

FUNCTION {format.publisher}
{ publisher empty$
    { "" }
    { "" publisher *}
  if$
}

FUNCTION {format.key}
{ empty$
    { key field.or.null }
    { "" }
  if$
}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to Format authors name, just prints out that nice   % 
% and then the formatted name by calling format.names.         %    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

FUNCTION {format.authors}
{ author empty$
    { "" }
    { "" author format.names * }
  if$
  format.collaboration *
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to format editors                                   %
% knows the difference between one editor "ed."                % 
% and more than one "eds."                                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

FUNCTION {format.editors}
{ editor empty$
    { "" }
    { "" editor format.names *
      editor num.names$ #1 >
        { ", eds." * }
        { ", ed." * }
      if$
    }
  if$
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to format title                                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

FUNCTION {format.title}
{ title empty$
    { "" }
    { "``" title * "''" *}
  if$
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to format the url field                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

FUNCTION {format.url}
{ cited empty$
    { "there's a URL, but no access date given in " cite$ * warning$
      "URL: \newline\url{" * url * "}" * 
    }
    { "URL (accessed " cited * "): \newline\url{" * url * "}" * 
    }
  if$
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to format the onlineversion field                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

FUNCTION {format.onlineversion}
{ cited empty$
    { "there's a onlineversion, but no access date given in " cite$ * warning$
       "Online version: \newline\url{" * onlineversion * "}" * 
    }
    { "Online version (accessed " cited * "): \newline\url{" * onlineversion * "}" * 
    }
  if$
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Two functions to format the doi field                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% shows and links doi
%FUNCTION {format.doi}
%{ doi empty$
%    { "" }
%    {" \href{http://dx.doi.org/" doi * "}{doi:" * doi * "}" *} 
%  if$
%}

% shows DOI and links doi
FUNCTION {format.doi}
{ doi empty$
    { "" }
    {"{\small[\href{http://dx.doi.org/" doi * "}{DOI" * "}]}" *} 
  if$
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Two functions to format the adsurl field                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

FUNCTION {format.adsurl}
{ adsurl empty$
    { "" }
    { "\newline ADS: \url{" adsurl * "}" * }
  if$
}

FUNCTION {format.ads}
{ adsurl empty$
    { "" }
    { "{\small[\href{" adsurl * "}" * "{ADS}]}" *}
  if$
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to format the ark field                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

FUNCTION {format.ark}
{ ark empty$
    { "" }
    { "{\small[\href{" ark * "}" * "{ARK}]}" *}
  if$
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to format arXiv eprints                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

FUNCTION {format.archive}
{
  archivePrefix empty$
      { "" }
      { archivePrefix ":" *}
  if$            
}

FUNCTION {format.primaryClass}
{
  primaryClass empty$
      { "" }
      { " {\small[" primaryClass * "]}" *}
  if$            
}

FUNCTION {format.eprint}
{ eprint empty$
     { ""}
     { archive empty$
          {"{\small[\href{http://arxiv.org/abs/" eprint * "}" * 
             "{{" * format.archive * eprint *
              format.primaryClass * "}}]}" *}
          {"{\small[\href{" archive *  "/" * eprint * "}" * 
             "{{" * format.archive * eprint *
              format.primaryClass * "}}]}" *}
       if$
     }
     if$
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to format the gbs_id                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

FUNCTION {format.gbs}
{ gbs_id empty$
    { "" }
    {"{\small[\href{http://books.google.com/books?id=" gbs_id * "}{Google Books" * "}]}" *} 
  if$
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to format the address field                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

FUNCTION {format.address}
{ address empty$
    { "" }
    { "" address *}
  if$
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to format the conference field                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

FUNCTION {format.conference}
{ conference empty$
    { "" }
    { "" conference *}
  if$
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to format the journal field                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

FUNCTION {format.journal}
{ journal empty$
    { "" }
    { "" journal emphasize * }
  if$
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to format the newspaper field                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

FUNCTION {format.newspaper}
{ newspaper empty$
    { "" }
    { "" newspaper emphasize * }
  if$
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% dash, e.g. in between page numbers                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

FUNCTION {n.dashify}
{ 't :=
  ""
    { t empty$ not }
    { t #1 #1 substring$ "-" =
    { t #1 #2 substring$ "--" = not
        { "--" *
          t #2 global.max$ substring$ 't :=
        }
        {   { t #1 #1 substring$ "-" = }
        { "-" *
          t #2 global.max$ substring$ 't :=
        }
          while$
        }
      if$
    }
    { t #1 #1 substring$ *
      t #2 global.max$ substring$ 't :=
    }
      if$
    }
  while$
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to format the date                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

FUNCTION {format.date}
{ year empty$
    { month empty$
        {
	  day empty$
	    { "" }
	    { "there's a day but no month or year in " cite$ * warning$ }
	  if$
	}
        { "there's a month but no year in " cite$ * warning$
          month
	  day empty$
            { }
	    { " " * day * }
          if$
        }
      if$
    }
    { month empty$
	{
	  day empty$
	    { "(" year * ")" * }
	    { "there's a day and year but no month in " cite$ * warning$ }
	  if$
	}
        {
         "(" month * " " *
	  day empty$
            { }
	    { day * ", " * }
          if$
          year * ")" *
        }
      if$
    }
  if$
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to emphasize a title                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

FUNCTION {format.btitle}
{ "{\em " title * "}" *
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to put a couple items together, with one of those   %
% little spaces (~) or a big space ( )                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

FUNCTION {tie.or.space.connect}
{ duplicate$ text.length$ #3 <
    { "~" }
    { " " }
  if$
  swap$ * *
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to check you are using ONE OF TWO possiblities,     %
% mutually exclusive                                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

FUNCTION {either.or.check}
{ empty$
    { pop$ }
    { "can't use both " swap$ * " fields in " * cite$ * warning$ }
  if$
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to output volume and number (if they exist naturally)%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

FUNCTION {format.bvolume}
{ volume empty$
    { "" }
    { series empty$
        'skip$
        { ", " * series * }
      if$
      volume
      "volume and number" number either.or.check
    }
  if$
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to output volume                                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

FUNCTION {format.volume}
{ volume empty$
   { "there is no volume in " cite$ * warning$ }
   { volume bold output } 
  if$
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to format number and series                          %
% but only if volume DOES NOT exist!                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% NO warning if volume doesn't exist
%   --> will not process series or number if volume exists

FUNCTION {format.number.series}
{ volume empty$
    { number empty$
        { series field.or.null }
        { output.state mid.sentence =
            { "number" }
            { "Number" }
          if$
         number tie.or.space.connect
         series empty$
            { "there's a number but no series in " cite$ * warning$ }
            { " in " * series * }
          if$
        }
      if$
    }
    { "" }
  if$
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to format edition field                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

FUNCTION {format.edition}
{ edition empty$
    { "" }
    { output.state mid.sentence =
        { edition "l" change.case$ " edition" * }
        { edition "t" change.case$ " edition" * }
      if$
    }
  if$
}

INTEGERS { multiresult }

FUNCTION {multi.page.check}
{ 't :=
  #0 'multiresult :=
    { multiresult not
      t empty$ not
      and
    }
    { t #1 #1 substring$
      duplicate$ "-" =
      swap$ duplicate$ "," =
      swap$ "+" =
      or or
    { #1 'multiresult := }
    { t #2 global.max$ substring$ 't := }
      if$
    }
  while$
  multiresult
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to format pages (or eid).                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

FUNCTION {format.pages}
{ eid empty$
    { pages empty$
	{ "there are no pages in " cite$ * warning$ "" }
	{ pages multi.page.check
            { "pp." pages n.dashify tie.or.space.connect }
            { "p." pages tie.or.space.connect }
	  if$
	}
      if$
    }
    { "" eid * }
  if$
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to format the volume, number, and pages (eid)         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

FUNCTION {format.vol.num.pages}
{ volume empty$
    { "there is no volume in " cite$ * warning$ }
    { "" volume bold * }
  if$
  number empty$
    { skip$ }
    { "(" number * ")" * *
      volume empty$
        { "there's a number but no volume in " cite$ * warning$ }
        { skip$ }
      if$
    }
  if$
  eid empty$
    { pages empty$
	{ "there are no pages in " cite$ * warning$ }
	{ duplicate$ empty$
            { pop$ format.pages }
            { ", " * pages n.dashify * }
	  if$
	}
      if$
    }
    { ", " eid * "" * * }
  if$
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to format the publisher/year/address fields           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

FUNCTION {format.publisher.address.year}
{ publisher empty$
    { address empty$
        { year empty$
            { "there is no publisher, address and year in " cite$ * warning$}
            { "there is no publisher and address in " cite$ * warning$
               "(" year * ")" *}
          if$
        }
        { year empty$
            { "(" address * ")" *
               "there's an address but no publisher and year in " cite$ * warning$ }
            { "there's no publisher in " cite$ * warning$
              "(" address * ", " * year * ")" *
            }
          if$
        }
      if$
     }
     { address empty$
         { year empty$
             { "there's no address and year in " cite$ * warning$ 
               "(" publisher * ")" *
             }
             { "there's no address in " cite$ * warning$
                "(" publisher * ", " * year * ")" *
             }
           if$
         }
         { year empty$
             { "there's no year in " cite$ * warning$ 
                "(" publisher * ", " * address * ")" * }
             { "(" publisher * ", " * address * ", " * year * ")" * }
           if$
         }
      if$
    }
  if$
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to format the school/address/year fields              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

FUNCTION {format.school.address.year}
{ school empty$
     { address empty$
         { year empty$
            { "there is no school, address and year in " cite$ * warning$}
            { "there is no school and address in " cite$ * warning$
               "(" year * ")" *}
            if$
         }
         { year empty$
             { "(" address * ")" *
                "there's an address but no school and year in " cite$ * warning$ }
             { "there's no school in " cite$ * warning$
               "(" address * ", " * year * ")" *
             }
           if$
         }
         if$
      }
     { address empty$
         { year empty$
             { "there's no address and year in " cite$ * warning$ 
                "(" school * ")" *
             }
             { "there's no address in " cite$ * warning$
                "(" school * ", " * year * ")" *
             }
            if$
          }
          { year empty$
               { "there's no year in " cite$ * warning$ 
                  "(" school * ", " * address * ")" * }
               { "(" school * ", " * address * ", " * year * ")" * }
            if$
         }
      if$
    }
  if$
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to format publisher/address/year for technical reports%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

FUNCTION {format.tr.publisher.address.year}
{ publisher empty$
     { address empty$
         { year empty$
            { "there is no publisher, address and year in " cite$ * warning$}
            { "there is no publisher and address in " cite$ * warning$
               "(" year * ")" *}
            if$
         }
         { year empty$
             { "(" address * ")" *
                "there's an address but no publisher and year in " cite$ * warning$ }
             { "there's no publisher in " cite$ * warning$
               "(" address * ", " * year * ")" *
             }
           if$
         }
         if$
      }
     { address empty$
         { year empty$
             { "there's no address and year in " cite$ * warning$ 
                "(" publisher * ")" *
             }
             { "there's no address in " cite$ * warning$
                "(" publisher * ", " * year * ")" *
             }
            if$
          }
          { year empty$
               { "there's no year in " cite$ * warning$ 
                  "(" publisher * ", " * address * ")" * }
               { "(" publisher * ", " * address * ", " * year * ")" * }
            if$
         }
      if$
    }
  if$
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to format keywords                                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

FUNCTION {format.keywords}
% { keywords empty$
%    { " !!! K E Y W O R D S missing in " cite$ * warning$ }
%    { "" }
%    if$
% }
% disabled warning
{ keywords empty$
   { "" }
   { "" }
   if$
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function for format chapter and pages                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

FUNCTION {format.chapter.pages}
{ chapter empty$
    'format.pages
    { type empty$
        { "" }
        { type "l" change.case$ }
      if$
      chapter tie.or.space.connect
      pages empty$
        { skip$ }
        { ", " * format.pages * }
      if$
    }
  if$
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

FUNCTION {format.in.ed.booktitle}
{ booktitle empty$
    { "" }
    { editor empty$
        { "in " booktitle emphasize * }
        { "in " format.editors * ", " * booktitle emphasize * }
      if$
    }
  if$
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to format unknown status or format                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

FUNCTION {format.misc.format}
{ format empty$
    { skip$ }
    { format "unknown" =
        { bbl.unknown.format }   
        { bbl.default.format 
        }
     if$
    }
  if$
}


FUNCTION {format.unpublished.format}
{ format empty$
    { skip$ }
    { format "unknown" =
        { bbl.unknown.status}   
        { bbl.default.status
        }
     if$
    }
  if$
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to format other format of online resource             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

FUNCTION {format.online.format}
{ format empty$
    { skip$ }
    { format "other" =
        { bbl.other.format}   
        { bbl.default.format
        }
     if$
    }
  if$
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to format preprint type (=format)                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

FUNCTION {format.preprint.format}
{ archivePrefix empty$
    { "e-print" }
    { ", " * archivePrefix emphasize * "e-print" }
 if$
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to format thesis type                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

FUNCTION {format.thesis.type}
{ type empty$
    'skip$
    { pop$
      type "t" change.case$
    }
  if$
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to output citation style "article"                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

FUNCTION {article}
{ output.bibitem
  "" write$ newline$ ""
  format.authors "author" output.check
  format.title "title" output.check
  format.journal "journal" output.check
  format.vol.num.pages "pages" output.check
  add.blank
  format.date "year" output.check
  new.sentence
  format.doi output
  format.ads output
  format.ark output
  format.eprint output
  new.sentence
  url empty$
    { skip$ }
    { format.url "url" output.check
      new.sentence
    }
  if$
  onlineversion empty$
    { skip$ }
    { format.onlineversion "onlineversion" output.check
      new.sentence
    }
  if$
  note output
  format.keywords output
  fin.entry
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to output citation style "newspaperarticle"                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

FUNCTION {newspaperarticle}
{ output.bibitem
  "" write$ newline$ ""
  format.authors "author" output.check
  format.title "title" output.check
  format.newspaper "newspaper" output.check
  format.date "year" output.check
  format.pages output
  new.sentence
  format.doi output
  format.ads output
  format.eprint output
  new.sentence
  url empty$
    { skip$ }
    { format.url "url" output.check
      new.sentence
    }
  if$
  onlineversion empty$
    { skip$ }
    { format.onlineversion "onlineversion" output.check
      new.sentence
    }
  if$
  note output
  format.keywords output
  fin.entry
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to output citation style "book"                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

FUNCTION {book}
{ output.bibitem
  "" write$ newline$ ""
  author empty$
    { format.editors "author and editor" output.check }
    { format.authors output.nonnull }
  if$
  format.btitle "title" output.check
  format.bvolume output
  format.number.series output
  format.publisher.address.year "year" output.check
  format.edition output
  new.sentence
  format.doi output
  format.ads output
  format.eprint output
  format.gbs output
  new.sentence
  url empty$
    { skip$ }
    { format.url "url" output.check
      new.sentence
    }
  if$
  onlineversion empty$
    { skip$ }
    { format.onlineversion "onlineversion" output.check
      new.sentence
    }
  if$
  note output
  format.keywords output
  fin.entry
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to output citation style "inbook"                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

FUNCTION {inbook}
{ output.bibitem
  "" write$ newline$ ""
  format.authors "author" output.check
  format.title "title" output.check
  format.in.ed.booktitle "booktitle" output.check
  format.bvolume output
  format.chapter.pages "chapter and pages" output.check
  format.number.series output
  format.publisher.address.year "year" output.check
  format.edition output
  new.sentence
  format.doi output
  format.ads output
  format.eprint output
  format.gbs output
  url empty$
    { skip$ }
    { format.url "url" output.check
      new.sentence
    }
  if$
  onlineversion empty$
    { skip$ }
    {format.onlineversion "onlineversion" output.check
    new.sentence
    }
  if$
  note output
  format.keywords output 
  fin.entry
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to output citation style "inproceedings"              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

FUNCTION {inproceedings}
{ output.bibitem
  "" write$ newline$ ""
  format.authors "author" output.check
  format.title "title" output.check
  format.in.ed.booktitle "booktitle" output.check
  format.conference "conference" output.check
  format.bvolume output
  format.number.series output
  format.pages output
  address empty$
    { organization publisher new.sentence.checkb
      organization output
      publisher output
      format.date "year" output.check
    }
    { format.publisher.address.year output
      organization output
    }
  if$
  new.sentence
  format.doi output
  format.ads output
  format.eprint output
  format.gbs output
  new.sentence
  url empty$
    { skip$ }
    {format.url "url" output.check
    new.sentence
    }
  if$
  onlineversion empty$
    { skip$ }
    { format.onlineversion "onlineversion" output.check
      new.sentence
    }
  if$
  note output
  format.keywords output
  fin.entry
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to output citation style "thesis"                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

FUNCTION {phdthesis}
{ output.bibitem
  "" write$ newline$ ""
  format.authors "author" output.check
  format.btitle "title" output.check
  bbl.phdthesis format.thesis.type output.nonnull
  format.school.address.year "year" output.check
  new.sentence
  format.doi output
  format.ads output
  format.eprint output
  new.sentence
  url empty$
    { skip$ }
    {format.url "url" output.check
    new.sentence
    }
  if$
  onlineversion empty$
    { skip$ }
    {format.onlineversion "onlineversion" output.check
    new.sentence
    }
  if$
  note output
  format.keywords output 
  fin.entry
}

FUNCTION {mastersthesis}
{ output.bibitem
  "" write$ newline$ ""
  format.authors "author" output.check
  format.btitle "title" output.check
  bbl.mthesis format.thesis.type output.nonnull
  format.school.address.year "year" output.check
  new.sentence
  format.doi output
  format.ads output
  format.eprint output
  new.sentence
  url empty$
    { skip$ }
    {format.url "url" output.check
    new.sentence
    }
  if$
  onlineversion empty$
    { skip$ }
    {format.onlineversion "onlineversion" output.check
    new.sentence
    }
  if$
  note output
  format.keywords output 
  fin.entry
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to output citation style "misc"                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

FUNCTION {misc}
{ output.bibitem
  "" write$ newline$ ""
  format.authors output
  format.title output
  format.misc.format output
  format.date output
  new.sentence
  note output
  format.keywords output
  fin.entry
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function for citation style "online"                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% If no author is given, the entry is sorted by its title in the
% reference list. Consider using an additional 'key' field.

FUNCTION {online}
{ output.bibitem
  "" write$ newline$ ""
  author empty$
    { skip$ }
    { format.authors "author" output.check }
   if$
  format.title "title" output.check
  format.conference output
  format.online.format output.nonnull
  publisher "publisher" output.check
  format.date output
  new.sentence
  format.url "url" output.check
  new.sentence
  note output
  format.keywords output
  fin.entry
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to output citation style "proceedings"                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

FUNCTION {proceedings}
{ output.bibitem
  "" write$ newline$ ""
  editor empty$
    { organization output }
    { format.editors output.nonnull 
    }
  if$
  format.btitle "title" output.check
  format.conference "conference" output.check
  format.bvolume output
  format.number.series output
  address empty$
    { editor empty$
        { publisher new.sentence.checka }
        { organization publisher new.sentence.checkb
        organization output
        }
      if$
      publisher output
      format.date "year" output.check
    }
    { format.publisher.address.year output
      editor empty$
        { skip$ }
        { organization output }
      if$
    }
  if$
  new.sentence
  format.doi output
  format.ads output
  format.eprint output
  format.gbs output
  new.sentence
  url empty$
    { skip$ }
    { format.url "url" output.check
      new.sentence
    }
  if$
  onlineversion empty$
    { skip$ }
    { format.onlineversion "onlineversion" output.check
      new.sentence
    }
  if$
  note output
  format.keywords output
  fin.entry
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to output citation style "incollection"               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

FUNCTION {incollection}
{ output.bibitem
   "" write$ newline$ "" 
  format.authors "author" output.check
  format.title "title" output.check
  format.in.ed.booktitle "booktitle" output.check
  format.bvolume output
  format.number.series output
  format.chapter.pages output
  address empty$
    { organization publisher new.sentence.checkb
      organization output
      publisher output
      format.date "year" output.check
    }
    { format.publisher.address.year output
      organization output
    }
  if$
  new.sentence
  format.doi output
  format.ads output
  format.eprint output
  format.gbs output
  new.sentence
  url empty$
    { skip$ }
    {format.url "url" output.check
    new.sentence
    }
  if$
  onlineversion empty$
    { skip$ }
    {format.onlineversion "onlineversion" output.check
    new.sentence
    }
  if$
  note output  
  format.keywords output
  fin.entry
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to output citation style "techreport"                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

FUNCTION {techreport}
{ output.bibitem
  "" write$ newline$ ""
%  format.authors output
  author empty$
    { collaboration empty$
        { format.key output }
        { collaboration "collaboration" output.check }
      if$
    }
    { format.authors "author" output.check }
  if$
  format.btitle "title" output.check
  format.tr.series output
  format.tr.publisher.address.year output
  format.edition output
  new.sentence
  format.doi output
  format.ads output
  format.eprint output
  format.gbs output
  new.sentence
  url empty$
    { skip$ }
    {format.url "url" output.check
    new.sentence
    }
  if$
  onlineversion empty$
    { skip$ }
    {format.onlineversion "onlineversion" output.check
    new.sentence
    }
  if$
  note output
  format.keywords output
  fin.entry
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to output citation style "preprint"                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

FUNCTION {preprint}
{ output.bibitem
  "" write$ newline$ ""
  format.authors "author" output.check
  format.title "title" output.check
  format.preprint.format output.nonnull
  format.date "year" output.check
  new.sentence
  format.ads output
  format.eprint output
  new.sentence
  url empty$
    { skip$ }
    {format.url "url" output.check
    new.sentence
    }
  if$
  onlineversion empty$
    { skip$ }
    {format.onlineversion "onlineversion" output.check
    new.sentence
    }
  if$
  new.sentence
  note output
  format.keywords output
  fin.entry
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to output citation style "unpublished"                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

FUNCTION {unpublished}
{ output.bibitem
  "" write$ newline$ ""
  format.authors "author" output.check
  format.title "title" output.check
  format.journal output
  format.conference output
  format.unpublished.format "format" output.check
  format.date output
  new.sentence
  format.doi output
  format.ads output
  format.eprint output
  new.sentence
  url empty$
    { skip$ }
    { format.url "url" output.check
      new.sentence
    }
  if$
  onlineversion empty$
    { skip$ }
    { format.onlineversion "onlineversion" output.check
      new.sentence
    }
  if$
  new.sentence
  note output
  format.keywords output
  fin.entry
}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

FUNCTION {default.type} { misc }

MACRO {jan} {"January"}

MACRO {feb} {"February"}

MACRO {mar} {"March"}

MACRO {apr} {"April"}

MACRO {may} {"May"}

MACRO {jun} {"June"}

MACRO {jul} {"July"}

MACRO {aug} {"August"}

MACRO {sep} {"September"}

MACRO {oct} {"October"}

MACRO {nov} {"November"}

MACRO {dec} {"December"}

READ

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

FUNCTION {sortify}
{ purify$
  "l" change.case$
}

INTEGERS { len }

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

FUNCTION {chop.word}
{ 's :=
  'len :=
  s #1 len substring$ =
    { s len #1 + global.max$ substring$ }
    's
  if$
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

FUNCTION {sort.format.names}
{ 's :=
  #1 'nameptr :=
  ""
  s num.names$ 'numnames :=
  numnames #8 >
    { s nameptr
      "{vv{ } }{ll{ }}{  f{ }}{  jj{ }}"
      format.name$ 't :=
      t sortify *
      "   "  *
      "zzzzz" *
    }
    { numnames 'namesleft :=
      { namesleft #0 > }
      { s nameptr
        "{vv{ } }{ll{ }}{  f{ }}{  jj{ }}"
        format.name$ 't :=
        nameptr #1 >
          {
            "   "  *
            namesleft #1 = t "others" = and
              { "zzzzz" * }
              { t sortify * }
            if$
          }
          { t sortify * }
        if$
        nameptr #1 + 'nameptr :=
        namesleft #1 - 'namesleft :=
      }
    while$
    }
  if$
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

FUNCTION {sort.format.title}
{ 't :=
  "A " #2
    "An " #3
      "The " #4 t chop.word
    chop.word
  chop.word
  sortify
  #1 global.max$ substring$
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NEW: edited to use author, key, title                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

FUNCTION {author.sort}
%{ author empty$
%    { key empty$
%       { title empty$
%           {"to sort, need author or key in " cite$ * warning$
%           ""
%           }
%           { title sortify }
%           if$
%       }
%       { key sortify }
%         if$
%    }
%    { author sort.format.names }
%  if$
%}
% NEW 2010: added collaboration to sort check:
{ author empty$
    { collaboration empty$
        { key empty$
	    { title empty$
            { "to sort, need author, collaboration, or key in " cite$ * warning$
              ""
            }
            { title sortify }
            if$
	 }
            { key sortify }
         if$
        }
        { collaboration sortify }
      if$
    }
    { author sort.format.names }
  if$
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

FUNCTION {author.editor.sort}
{ author empty$
    { editor empty$
    { key empty$
        { "to sort, need author, editor, or key in " cite$ * warning$
          ""
        }
        { key sortify }
      if$
    }
    { editor sort.format.names }
      if$
    }
    { author sort.format.names }
  if$
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

FUNCTION {author.organization.sort}
{ author empty$
    { organization empty$
    { key empty$
        { "to sort, need author, organization, or key in " cite$ * warning$
          ""
        }
        { key sortify }
      if$
    }
    { "The " #4 organization chop.word sortify }
      if$
    }
    { author sort.format.names }
  if$
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

FUNCTION {editor.organization.sort}
{ editor empty$
    { organization empty$
    { key empty$
        { "to sort, need editor, organization, or key in " cite$ * warning$
          ""
        }
        { key sortify }
      if$
    }
    { "The " #4 organization chop.word sortify }
      if$
    }
    { editor sort.format.names }
  if$
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

FUNCTION {presort}
{ type$ "book" =
  type$ "inbook" =
  or
    'author.editor.sort
    { type$ "proceedings" =
    'editor.organization.sort
    { type$ "manual" =
        'author.organization.sort
        'author.sort
      if$
    }
      if$
    }
  if$
  "    "
  *
  year field.or.null sortify
  *
  "    "
  *
  title field.or.null
  sort.format.title
  *
  #1 entry.max$ substring$
  'sort.key$ :=
}

ITERATE {presort}

SORT

STRINGS { longest.label }

INTEGERS { number.label longest.label.width }

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

FUNCTION {initialize.longest.label}
{ "" 'longest.label :=
  #1 'number.label :=
  #0 'longest.label.width :=
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

FUNCTION {longest.label.pass}
{ number.label int.to.str$ 'label :=
  number.label #1 + 'number.label :=
  label width$ longest.label.width >
    { label 'longest.label :=
      label width$ 'longest.label.width :=
    }
    { skip$ }
  if$
}

EXECUTE {initialize.longest.label}

ITERATE {longest.label.pass}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

FUNCTION {begin.bib}
{ preamble$ empty$
    { skip$ }
    { preamble$ write$ newline$ }
  if$
  "\begin{thebibliography}{"  longest.label  * "}" * write$ newline$
}

EXECUTE {begin.bib}

EXECUTE {init.state.consts}

ITERATE {call.type$}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

FUNCTION {end.bib}
{ newline$
  "\end{thebibliography}" write$ newline$
}

EXECUTE {end.bib}
