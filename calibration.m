%% Calibration Using Signal Analyzer!!!!!!!!
%Difference of two Whole numbers!!!! NOT 454.4 buttttt 454
%Use two Data Cursors to find the time to take the difference between two
%points

one1=input('No weight');
one=input('Weight drop');
two2=input('Before Second weight drop');
two=input('Second weight drop');
three3=input('Before Third weight drop');x
three=input('Third weight drop');
four4=input('Before Fourth weight drop');
four=input('Fourth weight drop');
five5=input('Before Fifth weight drop');
five=input('Fifth weight drop');

%% Vertical weight differences
Vertweight1= zeroingData(one,1);
Vertzero1=zeroingData(one1,1);
diffVert1= Vertzero1-Vertweight1;

Vertweight2= zeroingData(two,1);
Vertzero2=zeroingData(two2,1);
diffVert2= Vertzero2-Vertweight2;

Vertweight3= zeroingData(three,1);
Vertzero3=zeroingData(three3,1);
diffVert3=Vertzero3- Vertweight3;

Vertweight4= zeroingData(four,1);
Vertzero4=zeroingData(four4,1);
diffVert4=Vertzero4- Vertweight4;

Vertweight5= zeroingData(five,1);
Vertzero5=zeroingData(five5,1);
diffVert5= Vertzero5- Vertweight5;

%% Foreaft weight difference 
Foraftweight1= zeroingData(one,2);
Foraftzero1=zeroingData(one1,2);
diffForaft1=Foraftzero1-Foraftweight1;

Foraftweight2= zeroingData(two,2);
Foraftzero2=zeroingData(two2,2);
diffForaft2=Foraftzero2-Foraftweight2;

Foraftweight3= zeroingData(three,2);
Foraftzero3=zeroingData(three3,2);
diffForaft3=Foraftzero3-Foraftweight3;

Foraftweight4= zeroingData(four,2);
Foraftzero4=zeroingData(four4,2);
diffForaft4=Foraftzero4-Foraftweight4;


Foraftweight5= zeroingData(five,2);
Foraftzero5=zeroingData(five5,2);
diffForaft5=Foraftzero5-Foraftweight5;

%% Lateral weight difference
Latweight1= zeroingData(one,3);
Latzero1=zeroingData(one1,3);
diffLat1= Latzero1-Latweight1;

Latweight2= zeroingData(two,3);
Latzero2=zeroingData(two2,3);
diffLat2= Latzero2-Latweight2;

Latweight3= zeroingData(three,3);
Latzero3=zeroingData(three3,3);
diffLat3=Latzero3-Latweight3 ;

Latweight4= zeroingData(four,3);
Latzero4=zeroingData(four4,3);
diffLat4= Latzero4-Latweight4;

Latweight5= zeroingData(five,3);
Latzero5=zeroingData(five5,3);
diffLat5=Latzero5-Latweight5;


%% Matrice of calibration

calibration = [diffVert1 diffForaft1 diffLat1;
               diffVert2 diffForaft2 diffLat2;
               diffVert3 diffForaft3 diffLat3;
               diffVert4 diffForaft4 diffLat4;
               diffVert5 diffForaft5 diffLat5];
           