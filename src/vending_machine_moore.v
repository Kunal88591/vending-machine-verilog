// Vending Machine Controller - Moore FSM Implementation
// Item Price: 7₹
// Accepts: 1₹, 2₹, 5₹ coins
// Returns change and dispenses item

module vending_machine_moore(
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
    parameter S7   = 4'd7;  // 7₹ collected - Dispense
    parameter S8   = 4'd8;  // 8₹ collected - Dispense + 1₹ change
    parameter S9   = 4'd9;  // 9₹ collected - Dispense + 2₹ change
    parameter S10  = 4'd10; // 10₹ collected - Dispense + 3₹ change

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
                    3'b101: next_state = S7;   // Total: 7₹
                    default: next_state = S2;
                endcase
            end
            
            S3: begin
                case (coin)
                    3'b001: next_state = S4;   // Total: 4₹
                    3'b010: next_state = S5;   // Total: 5₹
                    3'b101: next_state = S8;   // Total: 8₹
                    default: next_state = S3;
                endcase
            end
            
            S4: begin
                case (coin)
                    3'b001: next_state = S5;   // Total: 5₹
                    3'b010: next_state = S6;   // Total: 6₹
                    3'b101: next_state = S9;   // Total: 9₹
                    default: next_state = S4;
                endcase
            end
            
            S5: begin
                case (coin)
                    3'b001: next_state = S6;   // Total: 6₹
                    3'b010: next_state = S7;   // Total: 7₹
                    3'b101: next_state = S10;  // Total: 10₹
                    default: next_state = S5;
                endcase
            end
            
            S6: begin
                case (coin)
                    3'b001: next_state = S7;   // Total: 7₹
                    3'b010: next_state = S8;   // Total: 8₹
                    3'b101: next_state = S10;  // Total: 11₹ (cap at 10)
                    default: next_state = S6;
                endcase
            end
            
            S7, S8, S9, S10: next_state = IDLE; // After dispensing, return to IDLE
            
            default: next_state = IDLE;
        endcase
    end

    // Output logic (Moore - depends only on current state)
    always @(*) begin
        case (current_state)
            IDLE, S1, S2, S3, S4, S5, S6: begin
                dispense = 0;
                change = 3'b000;
                total = current_state; // Show current amount collected
            end
            
            S7: begin // 7₹ - Exact amount
                dispense = 1;
                change = 3'b000;
                total = 4'd7;
            end
            
            S8: begin // 8₹ - Return 1₹
                dispense = 1;
                change = 3'b001;
                total = 4'd8;
            end
            
            S9: begin // 9₹ - Return 2₹
                dispense = 1;
                change = 3'b010;
                total = 4'd9;
            end
            
            S10: begin // 10₹ - Return 3₹
                dispense = 1;
                change = 3'b011;
                total = 4'd10;
            end
            
            default: begin
                dispense = 0;
                change = 3'b000;
                total = 4'd0;
            end
        endcase
    end

endmodule
