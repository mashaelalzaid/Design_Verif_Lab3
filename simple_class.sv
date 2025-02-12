
/// DESIGN 
class simple_class;

//properties
bit [7:0] count;

//method

// function new (input  bit [7:0] temp = 0);
// this.count = temp;
// endfunction

function void load(input bit [7:0] count);
this.count = count;
endfunction


function int getcount();
return count;
endfunction

endclass


// /// TEST BENCH 

// module test;
// counter cnt1; //handle

// initial begin
//     cnt1=new;
//     $display("Count Value: %d", cnt1.getcount());

//     cnt1.count =0;
//     cnt1.load(8'h01);
//     $display("Count Value: %d", cnt1.getcount());
// end

// endmodule
