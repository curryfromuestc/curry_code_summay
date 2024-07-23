module vision_core(
    input [319:0]line_pixel,
    input clk,
    input rst_n,
    input start,
    output reg[16:0] cout_six,
    output reg[16:0] cout_o,
    output reg[16:0] cout_four,
    output reg data_update,
    output reg stop
);

parameter IDLE = 3'b000,PROCESS = 3'b001,MERGE = 3'b010,UPDATE = 3'b011,DONE = 3'b100;
reg [2:0]state,next_state;

reg[9:0]x_1,x_2,x_3,x_counter;
reg[8:0]y_1,y_2,y_3,y_counter;

reg[8:0]x_1_max,x_1_min,x_2_max,x_2_min,x_3_max,x_3_min,x_counter_max,x_counter_min;
reg[7:0]y_1_max,y_1_min,y_2_max,y_2_min,y_3_max,y_3_min,y_counter_max,y_counter_min;

reg[11:0]counter_1,counter_2,counter_3,counter;

reg[8:0]col;
reg[7:0]row;

reg[319:0]line_pixel_last;

wire new_area,same_area,scan_done,new_area_row;


//!判断是否为新连通域
assign new_area = (line_pixel[col] == 1)
                &&(line_pixel[col-1] == 0)
                &&(line_pixel_last[col-1] == 0)
                &&(line_pixel_last[col] == 0)
                &&(line_pixel_last[col+1] == 0);

//!判断是否属于同一个连通域
assign same_area = (line_pixel[col] == 1)
                &&((line_pixel[col-1] == 1)
                ||(line_pixel_last[col-1] == 1)
                ||(line_pixel_last[col] == 1)
                ||(line_pixel_last[col+1] == 1));

//!判断在这一行内，该连通域是否已经结束
assign scan_done = (line_pixel[col] == 1)&&(line_pixel[col+1] == 0);

//!判断在这一行内，一个新的连通域开始
assign new_area_row = (line_pixel[col] == 1)&&(line_pixel[col-1] == 0);

//!状态转移逻辑
always @(posedge clk or negedge rst_n) begin
    if(~rst_n)
        state <= IDLE;
    else
        state <= next_state;
end

//!下一状态逻辑
always @(*) begin
    case (state)
        IDLE:begin
            if(start)
                next_state = PROCESS;
            else
                next_state = IDLE; 
        end
        PROCESS:begin
            if(new_area)begin
                next_state = PROCESS;
            end
            else if(same_area)begin
                if(scan_done)
                    next_state = MERGE;
                else
                    next_state = PROCESS;
            end
            else if(col == 318)begin
                next_state = UPDATE;
            end
            else begin
                next_state = PROCESS;
            end
        end
        MERGE:begin
            next_state = PROCESS;
        end
        UPDATE:begin
            if(row == 239)
                next_state = DONE;
            else begin
                next_state = IDLE;
            end
        end
        DONE:begin
            next_state = IDLE;
        end
        default:next_state = IDLE;
    endcase
end

//!输出逻辑
always @(*) begin
    x_counter = (x_counter_max + x_counter_min) >> 1;
	y_counter = (y_counter_max + y_counter_min) >> 1;
	x_1 = (x_1_max + x_1_min) >> 1;
	y_1 = (y_1_max + y_1_min) >> 1;
	x_2 = (x_2_max + x_2_min) >> 1;
	y_2 = (y_2_max + y_2_min) >> 1;
	x_3 = (x_3_max + x_3_min) >> 1;
	y_3 = (y_3_max + y_3_min) >> 1;
    if (counter_1 > counter_2 &&counter_2 > counter_3)begin
        cout_four = {x_1[8:0],y_1[7:0]};
        cout_o = {x_2[8:0],y_2[7:0]};
        cout_six = {x_3[8:0],y_3[7:0]};
    end
    else if(counter_1 > counter_3&&counter_3 > counter_2)begin
        cout_four = {x_1[8:0],y_1[7:0]};
        cout_o = {x_3[8:0],y_3[7:0]};
        cout_six = {x_2[8:0],y_2[7:0]};
    end
    else if(counter_2 > counter_1&&counter_1 > counter_3)begin
        cout_four = {x_2[8:0],y_2[7:0]};
        cout_o = {x_1[8:0],y_1[7:0]};
        cout_six = {x_3[8:0],y_3[7:0]};
    end
    else if(counter_2 > counter_3&&counter_3 > counter_1)begin
        cout_four = {x_2[8:0],y_2[7:0]};
        cout_o = {x_3[8:0],y_3[7:0]};
        cout_six = {x_1[8:0],y_1[7:0]};
    end
    else if(counter_3 > counter_1&&counter_1 > counter_2)begin
        cout_four = {x_3[8:0],y_3[7:0]};
        cout_o = {x_1[8:0],y_1[7:0]};
        cout_six = {x_2[8:0],y_2[7:0]};
    end
    else if(counter_3 > counter_2&&counter_2 > counter_1)begin
        cout_four = {x_3[8:0],y_3[7:0]};
        cout_o = {x_2[8:0],y_2[7:0]};
        cout_six = {x_1[8:0],y_1[7:0]};
    end
    else begin
        cout_four = 0;
        cout_o = 0;
        cout_six = 0;
    end
end

//!寄存器逻辑
always @(posedge clk or negedge rst_n) begin
    if(~rst_n)begin
        col <= 0;
        row <= 0;
        counter <= 0;
        x_counter_max <= 0;
        x_counter_min <= 0;
        y_counter_max <= 0;
        y_counter_min <= 0;
        counter_1 <= 0;
        counter_2 <= 0;
        counter_3 <= 0;
        x_1_max <= 0;
        x_1_min <= 0;
        y_1_max <= 0;
        y_1_min <= 0;
        x_2_max <= 0;
        x_2_min <= 0;
        y_2_max <= 0;
        y_2_min <= 0;
        x_3_max <= 0;
        x_3_min <= 0;
        y_3_max <= 0;
        y_3_min <= 0;
        data_update <= 0;
        stop <= 0;
        line_pixel_last <= 0;
    end
    else begin
        case (state)
        IDLE:begin
			col <= col;
            row <= row;
            counter <= counter;
            x_counter_max <= x_counter_max;
            x_counter_min <= x_counter_min;
            y_counter_max <= y_counter_max;
            y_counter_min <= y_counter_min;
            counter_1 <= counter_1;
            counter_2 <= counter_2;
            counter_3 <= counter_3;
            x_1_max <= x_1_max;
            x_1_min <= x_1_min;
            y_1_max <= y_1_max;
            y_1_min <= y_1_min;
            x_2_max <= x_2_max;
            x_2_min <= x_2_min;
            y_2_max <= y_2_max;
            y_2_min <= y_2_min;
            x_3_max <= x_3_max;
            x_3_min <= x_3_min;
            y_3_max <= y_3_max;
            y_3_min <= y_3_min;
            data_update <= 0;
            stop <= stop;
            line_pixel_last <= line_pixel_last;
        end
        PROCESS:begin
            col <= col + 1;
            if(new_area)begin
                counter <= counter + 1;
                x_counter_max <= col;
                x_counter_min <= col;
                y_counter_max <= row;
                y_counter_min <= row;
            end
            else if(new_area_row)begin
                counter <= counter + 1;
                x_counter_min <= col;
            end
            else if(same_area)begin
                counter <= counter + 1;
                x_counter_max <= (col > x_counter_max)?col:x_counter_max;
                x_counter_min <= (col < x_counter_min)?col:x_counter_min;
                y_counter_max <= (row > y_counter_max)?row:y_counter_max;
                y_counter_min <= (row < y_counter_min)?row:y_counter_min;
            end
            else begin
                x_counter_max <= x_counter_max;
                x_counter_min <= x_counter_min;
                y_counter_max <= y_counter_max;
                y_counter_min <= y_counter_min;
                counter <= counter;
            end
        end
        MERGE:begin
            if(counter_1 == 0
            ||(x_counter<=(x_1_max+4)&&x_counter>=(x_1_min-4)&&y_counter_max<=(y_1_max+2)))begin
                if(counter_1 == 0)begin
                    x_1_max <= x_counter_max;
                    x_1_min <= x_counter_min;
                    y_1_max <= y_counter_max;
                    y_1_min <= y_counter_min;
                end
                else begin
                    x_1_max <= x_counter_max;
                    x_1_min <= x_counter_min;
                    y_1_max <= y_counter_max;
                    y_1_min <= y_1_min;
                end
                counter_1 <= counter_1 + counter;
                counter <= 0;
            end
            else if((counter_1 > 0&&counter_2 == 0)
            ||(x_counter<=(x_2_max+4)&&x_counter>=(x_2_min-4)&&y_counter_max<=(y_2_max+2)))begin
                if(counter_2 == 0)begin
                    x_2_max <= x_counter_max;
                    x_2_min <= x_counter_min;
                    y_2_max <= y_counter_max;
                    y_2_min <= y_counter_min;
                end
                else begin
                    x_2_max <= x_counter_max;
                    x_2_min <= x_counter_min;
                    y_2_max <= y_counter_max;
                    y_2_min <= y_2_min;
                end
                counter_2 <= counter_2 + counter;
                counter <= 0;
            end
            else if((counter_1 > 0&&counter_2 > 0&&counter_3 == 0)
            ||(x_counter<=(x_3_max+4)&&x_counter>=(x_3_min-4)&&y_counter_max<=(y_2_max+2)))begin
                if(counter_3 == 0)begin
                    x_3_max <= x_counter_max;
                    x_3_min <= x_counter_min;
                    y_3_max <= y_counter_max;
                    y_3_min <= y_counter_min;
                end
                else begin
                    x_3_max <= x_counter_max;
                    x_3_min <= x_counter_min;
                    y_3_max <= y_counter_max;
                    y_3_min <= y_3_min;
                end
                counter_3 <= counter_3 + counter;
                counter <= 0;
            end
            else begin
                x_1_max <= x_1_max;
                x_1_min <= x_1_min;
                y_1_max <= y_1_max;
                y_1_min <= y_1_min;
                counter_1 <= counter_1;
                x_2_max <= x_2_max;
                x_2_min <= x_2_min;
                y_2_max <= y_2_max;
                y_2_min <= y_2_min;
                counter_2 <= counter_2;
                x_3_max <= x_3_max;
                x_3_min <= x_3_min;
                y_3_max <= y_3_max;
                y_3_min <= y_3_min;
                counter_3 <= counter_3;
            end
        end
        UPDATE:begin
            col <= 0;
            row <= row + 1;
            line_pixel_last <= line_pixel;
            if(row == 239)
                data_update <= 0;
            else begin
                data_update <= 1;
            end
        end 
        DONE:begin
            stop <= 1;
        end
        default:begin
            col <= col;
            row <= row;
            counter <= counter;
            x_counter_max <= x_counter_max;
            x_counter_min <= x_counter_min;
            y_counter_max <= y_counter_max;
            y_counter_min <= y_counter_min;
            counter_1 <= counter_1;
            counter_2 <= counter_2;
            counter_3 <= counter_3;
            x_1_max <= x_1_max;
            x_1_min <= x_1_min;
            y_1_max <= y_1_max;
            y_1_min <= y_1_min;
            x_2_max <= x_2_max;
            x_2_min <= x_2_min;
            y_2_max <= y_2_max;
            y_2_min <= y_2_min;
            x_3_max <= x_3_max;
            x_3_min <= x_3_min;
            y_3_max <= y_3_max;
            y_3_min <= y_3_min;
            data_update <= data_update;
            stop <= stop;
            line_pixel_last <= line_pixel_last;
        end
    endcase
    end
end
endmodule