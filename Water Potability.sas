data work.project work.potable work.notpotable;
set work.import;
ph=round(ph,0.001);
Hardness=round(Hardness);
Solids=round(Solids);
Chloramines=round(Chloramines,0.01);
Sulfate=round(Sulfate);
Conductivity=round(Conductivity);
Organic_carbon=round(Organic_carbon,0.01);
Trihalomethanes=round(Trihalomethanes);
Turbidity=round(Turbidity,0.001);
select;
when (200<Conductivity<650 and 2.49<Organic_carbon<21.05 and 8<Trihalomethanes<125
and 1.49<Turbidity<6.10 and 6.195<ph<8.505 and 120<Hardness<220 and 728<Solids<560000
and 1.25<Chloramines<12.75 and 125<Sulfate<475) output work.potable;
otherwise output work.notpotable;
end;
run;

title 'Average Drinking Water Details';
proc means data=work.potable;
run;
title;

data work.ph;
set work.potable;
ph=round(ph);
run;

proc sort data=work.ph;
by ph;
run;

title 'Detailed Report for Drinkable Water';
proc means data = work.ph;
by ph;
run;
title;

title 'Drinking Water';
proc freq data=work.ph;
tables ph;
where 5<ph<9;
run;
title;


title 'pH Values of Drinking Water';
PROC TEMPLATE;
   DEFINE STATGRAPH pie;
      BEGINGRAPH;
         LAYOUT REGION;
            PIECHART CATEGORY = ph /
            DATALABELLOCATION = INSIDE
            DATALABELCONTENT = (percent)
            CATEGORYDIRECTION = CLOCKWISE
            START = 180 NAME = 'pie';
            DISCRETELEGEND 'pie' /
            TITLE = 'ph Values';
         ENDLAYOUT;
      ENDGRAPH;
   END;
RUN;
PROC SGRENDER DATA = work.ph
            TEMPLATE = pie;
RUN;
title;

data work.hardness;
set work.potable;
Hardness=round(Hardness,10);
run;

title 'Hardness of Drinking Water';
proc freq data=work.hardness;
tables Hardness;
where 110<Hardness<225;
run;
PROC TEMPLATE;
   DEFINE STATGRAPH pie;
      BEGINGRAPH;
         LAYOUT REGION;
            PIECHART CATEGORY = hardness /
            DATALABELLOCATION = INSIDE
            DATALABELCONTENT = (percent)
            CATEGORYDIRECTION = CLOCKWISE
            START = 180 NAME = 'pie';
            DISCRETELEGEND 'pie' /
            TITLE = 'Hardness';
         ENDLAYOUT;
      ENDGRAPH;
   END;
RUN;
PROC SGRENDER DATA = work.hardness
            TEMPLATE = pie;
RUN;
title;

title1 'Acidic Water OBS';
proc freq data=work.import nlevels;
tables ph /noprint;
where ph<7;
run;
title1;

title2 'Basic Water OBS';
proc freq data=work.import nlevels;
tables ph /noprint;
where ph>7;
run;
title2;