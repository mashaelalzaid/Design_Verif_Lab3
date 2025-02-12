

class counter;

//properties
bit [7:0] count;
    int max, min;

//method

function new (input  bit [7:0] temp = 8'h00, input int limit1 = 255, input int limit2 = 0);
        check_limit(limit1, limit2);  // Set max and min limits
        check_set(temp);              // Set initial count value
    endfunction


    function void load(input bit [7:0] new_value);
        check_set(new_value);
        $display("New Count Loaded: %d", count);
    endfunction

    // Method to check and assign max/min values
    function void check_limit(input int limit1, input int limit2);
        max = (limit1 > limit2) ? limit1 : limit2;
        min = (limit1 < limit2) ? limit1 : limit2;
    endfunction

    // Method to ensure the count is within limits
    function void check_set(input bit [7:0] temp);
        if (temp > max) begin
            count = max;
            $display("Warning: Initial count exceeds max limit. Set to max.");
        end else if (temp < min) begin
            count = min;
            $display("Warning: Initial count below min limit. Set to min.");
        end else begin
            count = temp;
        end
    endfunction


function int getcount();
return count;
endfunction

endclass



class upcounter extends counter;
 bit carry;
function new(input bit [7:0] temp = 8'h07, input int limit1 = 8'h99, input int limit2 = 0);

    super.new(temp, limit1, limit2);
  carry = 0;
endfunction

function void next();
  
        if (count >= max) begin
            carry =1;
            count = min;  // Wrap to min if count exceeds max
          
        end else begin
          carry =1
    count = count+1;
    end
    $display("Count Value: %d", this.getcount());
        
endfunction

endclass



class downcounter extends counter;
bit borrow =0;
function new(input bit [7:0] temp = 8'h07, input int limit1 = 0, input int limit2 = 8'h99);
    super.new(temp, limit1, limit2);
  borrow = 0;
endfunction

function void next();
        if (count > min) begin
          borrow =0;
count = count-1;
end else begin
  borrow =1;
            count = max;
        
        end
    $display("Count Value: %d", this.getcount());

endfunction

endclass


/// TEST BENCH 
`include "upcounter.sv"
`include "downcounter.sv"

module test;
    upcounter cnt1;
    downcounter cnt2;

    initial begin
        cnt1 = new();
        $display("Upcounter Initial Count Value: %d", cnt1.getcount());

        repeat(5) cnt1.next();  
        cnt2 = new();
        $display("Downcounter Initial Count Value: %d", cnt2.getcount());

        repeat(5) cnt2.next();  
    end
endmodule
