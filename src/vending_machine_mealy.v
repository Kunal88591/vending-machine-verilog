// Vending Machine Controller - Mealy FSM Implementation
// Item Price: 7₹
// Accepts: 1₹, 2₹, 5₹ coins
// Returns change and dispenses item

module vending_machine_mealy(
    input clk,
    input reset,
    input [2:0] coin,  // 3'b001 = 1₹, 3'b010 = 2₹, 3'b101 = 5₹
    output reg dispense,
    output reg [2:0] change,
    output reg [3:0] total
);

    // State encoding
    parameter IDLE = 4'd0;
    parameter S1   = 4'd1;  // 1₹ collected
    parameter S2   = 4'd2;  // 2₹ collected
    parameter S3   = 4'd3;  // 3₹ collected
    parameter S4   = 4'd4;  // 4₹ collected
    parameter S5   = 4'd5;  // 5₹ collected
    parameter S6   = 4'd6;  // 6₹ collected

    reg [3:0] current_state, next_state;

    // State transition (Sequential logic)
    always @(posedge clk or posedge reset) begin
        if (reset)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

    // Next state logic (Combinational logic)
    always @(*) begin
        case (current_state)
            IDLE: begin
                case (coin)
                    3'b001: next_state = S1;   // 1₹
                    3'b010: next_state = S2;   // 2₹
                    3'b101: next_state = S5;   // 5₹
                    default: next_state = IDLE;
                endcase
            end
            
            S1: begin
                case (coin)
                    3'b001: next_state = S2;   // Total: 2₹
                    3'b010: next_state = S3;   // Total: 3₹
                    3'b101: next_state = S6;   // Total: 6₹
                    default: next_state = S1;
                endcase
            end
            
            S2: begin
                case (coin)
                    3'b001: next_state = S3;   // Total: 3₹
                    3'b010: next_state = S4;   // Total: 4₹
                    3'b101: next_state = IDLE; // Total: 7₹ - Dispense & return
                    default: next_state = S2;
                endcase
            end
            
            S3: begin
                case (coin)
                    3'b001: next_state = S4;   // Total: 4₹
                    3'b010: next_state = S5;   // Total: 5₹
                    3'b101: next_state = IDLE; // Total: 8₹ - Dispense & return
                    default: next_state = S3;
                endcase
            end
            
            S4: begin
                case (coin)
                    3'b001: next_state = S5;   // Total: 5₹
                    3'b010: next_state = S6;   // Total: 6₹
                    3'b101: next_state = IDLE; // Total: 9₹ - Dispense & return
                    default: next_state = S4;
                endcase
            end
            
            S5: begin
                case (coin)
                    3'b001: next_state = S6;   // Total: 6₹
                    3'b010: next_state = IDLE; // Total: 7₹ - Dispense & return
                    3'b101: next_state = IDLE; // Total: 10₹ - Dispense & return
                    default: next_state = S5;
                endcase
            end
            
            S6: begin
                case (coin)
                    3'b001: next_state = IDLE; // Total: 7₹ - Dispense & return
                    3'b010: next_state = IDLE; // Total: 8₹ - Dispense & return
                    3'b101: next_state = IDLE; // Total: 11₹ - Dispense & return (cap at 10)
                    default: next_state = S6;
                endcase
            end
            
            default: next_state = IDLE;
        endcase
    end

    // Output logic (Mealy - depends on current state AND input)
    always @(*) begin
        // Default values
        dispense = 0;
        change = 3'b000;
        total = current_state;
        
        case (current_state)
            IDLE: begin
                total = 4'd0;
            end
            
            S1: begin
                total = 4'd1;
            end
            
            S2: begin
                total = 4'd2;
                // Check if next coin will trigger dispense
                if (coin == 3'b101) begin // Adding 5₹ makes 7₹
                    dispense = 1;
                    change = 3'b000;
                    total = 4'd7;
                end
            end
            
            S3: begin
                total = 4'd3;
                if (coin == 3'b101) begin // Adding 5₹ makes 8₹
                    dispense = 1;
                    change = 3'b001; // Return 1₹
                    total = 4'd8;
                end
            end
            
            S4: begin
                total = 4'd4;
                if (coin == 3'b101) begin // Adding 5₹ makes 9₹
                    dispense = 1;
                    change = 3'b010; // Return 2₹
                    total = 4'd9;
                end
            end
            
            S5: begin
                total = 4'd5;
                if (coin == 3'b010) begin // Adding 2₹ makes 7₹
                    dispense = 1;
                    change = 3'b000;
                    total = 4'd7;
                end
                else if (coin == 3'b101) begin // Adding 5₹ makes 10₹
                    dispense = 1;
                    change = 3'b011; // Return 3₹
                    total = 4'd10;
                end
            end
            
            S6: begin
                total = 4'd6;
                if (coin == 3'b001) begin // Adding 1₹ makes 7₹
                    dispense = 1;
                    change = 3'b000;
                    total = 4'd7;
                end
                else if (coin == 3'b010) begin // Adding 2₹ makes 8₹
                    dispense = 1;
                    change = 3'b001; // Return 1₹
                    total = 4'd8;
                end
                else if (coin == 3'b101) begin // Adding 5₹ makes 11₹ (cap at 10)
                    dispense = 1;
                    change = 3'b011; // Return 3₹
                    total = 4'd10;
                end
            end
            
            default: begin
                dispense = 0;
                change = 3'b000;
                total = 4'd0;
            end
        endcase
    end

endmodule
