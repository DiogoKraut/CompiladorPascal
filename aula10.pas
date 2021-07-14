program proc1 (input, output); 
  var x, y: integer;      
  procedure p;             
     var z:integer;  
     procedure q;
        var q1 : integer;
        begin
            if(1=1)
            then x:=q1
        end            
     begin                   
       z:=x;                   
       x:=x-1;           
       if (z>1)                   
         then p
         else y:=x; 
       y:=y*z      
     end
begin                     
   read(x);            
   p;
   if(1=1)
   then write (x,y)             
end.
