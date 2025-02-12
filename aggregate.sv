`include "static_members.sv"

class timer;

      upcounter hours, minutes, seconds;

    // Constructor
    function new(input int h = 0, input int m = 0, input int s = 0);

        hours   = new();  
        minutes = new(); 
        seconds = new(); 


        hours.check_limit(23, 0);   
        minutes.check_limit(59, 0); 
        seconds.check_limit(59, 0); 

        load(h, m, s);
    endfunction

    function void load(input int h, input int m, input int s);
        hours.load(h);
        minutes.load(m);
        seconds.load(s);
    endfunction

    function void showval();
        $display("Time: %02d:%02d:%02d", hours.getcount(), minutes.getcount(), seconds.getcount());
    endfunction

    function void next();
        seconds.next(); 
      
        // If seconds rolled over increment minutes
        if (seconds.carry) begin
            minutes.next();
        end

        // If minutes rolled over increment hours
        if (minutes.carry) begin
            hours.next();
        end

        showval();
    endfunction
endclass



// TEST BENCH
module test;
    timer t1;

    initial begin
        t1 = new(0, 0, 59);
        $display("Initial Timer:");
        t1.showval();

        t1.next(); 
      

        t1.load(0, 59, 59);
        $display("Testing Full Hour Roll-Over:");
        t1.showval();
        t1.next(); 

        t1.load(23, 59, 59);
        $display("Testing Full Day Roll-Over:");
        t1.showval();
        t1.next(); 
    end
endmodule
