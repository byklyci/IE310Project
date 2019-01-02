*YUSUF KALAYCI 2016400357
*HİLAL DEMİR 2014400018

Set

   j "customers index"
/
$include C:\Users\byklyci\Desktop\ie310project\customers.txt
/
   l "number of small trucks" /1 * 56 /
   i "number of large trucks" /1 * 56 /
   k "type of the truck" /small ,large / ;

    Alias (j,w) ;


Parameters
  
  a(j,w) customer j and w can be visited by same truck in direct delivery
/
$include C:\Users\byklyci\Desktop\ie310project\clusterability.txt
/

  dv(j) amount of order of customer j in volume
/
$include C:\Users\byklyci\Desktop\ie310project\demand-volume.txt
/

  dw(j) amount of order of customer j in weight
/
$include C:\Users\byklyci\Desktop\ie310project\demand-weight.txt
/
  u(j) unit cost for indirect delivery
/
$include C:\Users\byklyci\Desktop\ie310project\trans_cost.txt
/  

Table c(j,k) cost visiting j with direct delivery with truck type k
$include C:\Users\byklyci\Desktop\ie310project\direct-shipment-cost.txt
;


Variables
X(j)        type of delivery to customer j(0 is direct and 1 is indirect)
T(i,j)      large truck i serves j(1 it serves 0 otherwise)
S(l,j)      small truck l serves j(1 it serves 0 otherwise)
Max1(i)     largest cost of the customers visited by large truck
Max2(l)     largest cost of the customers visited by small truck
Z           total delivery cost;

Binary Variables X
                 T
                 S ;
                 
Positive Variables Max1
                   Max2 ;


Equations

    total_cost         define objective function for minimizing total cost 
    cs1(i)             cs1 at most three customer can be visited by a large truck
    cs2(l)             cs2 at most three customer can be visited by a small truck
    cs3(i)             cs3 volume capacity of large truck
    cs4(l)             cs4 volume capacity of small truck
    cs5(j)             cs5 selection direct delivery and the type of the truck(small or large)
    cs6(i,j)           cs6 the largest cost of the customers visited with large truck
    cs7(l,j)           cs7 the largest cost of the customers visited with small truck
    cs8(i,w)           cs8 costumer can be visited together with large truck(clusterability)
    cs9(l,w)           cs9 costumer can be visited together with small truck(clusterability)
    ;
    
 
    
 total_cost..      Z =e= sum(i,Max1(i))+ (sum((i,j),T(i,j))-1)*250 +
                         sum(l,Max2(l))+ (sum((l,j),S(l,j))-1)*125 +
                         sum(j,X(j)*dw(j)*u(j)) ;

 cs1(i)..                sum(j,T(i,j)) =l= 3;
 cs2(l)..                sum(j,S(l,j)) =l= 3;
 cs3(i)..                sum(j,T(i,j)*dv(j)) =l= 33;
 cs4(l)..                sum(j,S(l,j)*dv(j)) =l= 18;
 cs5(j)..                X(j) + sum(i,T(i,j)) + sum(l,S(l,j)) =e= 1;
 cs6(i,j)..              T(i,j)*c(j,'large') =l= Max1(i);
 cs7(l,j)..              S(l,j)*c(j,'small') =l= Max2(l);
 cs8(i,w)..              sum(j,a(j,w)) =g= sum(j,T(i,j));
 cs9(l,w)..              sum(j,a(j,w)) =g= sum(j,S(l,j));
              



Model delivering /all/ ;
Solve delivering using MIP minimizing Z;
display Z.L,X.L,T.L,S.L,Max1.L,Max2.L;





