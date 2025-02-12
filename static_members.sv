

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
  // Roll-over  
  bit carry;
  
  // Static property 
  static int instance_count = 0;

function new(input bit [7:0] temp = 8'h07, input int limit1 = 8'h99, input int limit2 = 0);

    super.new(temp, limit1, limit2);
    carry = 0;
    instance_count++;
endfunction
  
  //instance count
  static function int get_inst_count();
    return instance_count;
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
//roll-over
  bit borrow =0;
  //static
  static int instance_count=-;
  
function new(input bit [7:0] temp = 8'h07, input int limit1 = 0, input int limit2 = 8'h99);
    super.new(temp, limit1, limit2);
  borrow = 0;
  instance_count++;
endfunction

  //instance count
    static function int get_inst_count();
    return instance_count;
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
    upcounter cnt1, cnt2;
    downcounter cnt3, cnt4;

    initial begin
        // Instantiate two upcounter objects
        cnt1 = new();
        cnt2 = new();

        // Instantiate two downcounter objects
        cnt3 = new();
        cnt4 = new();

        // Display the instance counts
        $display("Upcounter Instances Created: %d", upcounter::get_instance_count());
        $display("Downcounter Instances Created: %d", downcounter::get_instance_count());

        // Run some operations
        cnt1.next();
        cnt2.next();
        cnt3.next();
        cnt4.next();
    end
endmodule
