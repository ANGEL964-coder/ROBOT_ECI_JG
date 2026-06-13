module pwm (
    input  wire        clk,
    input  wire        rst_n,       
    output reg         Q_motor_der,
    output reg         Q_motor_izq,
    input  wire signed [7:0] error
);
    reg [7:0] duty_motor_der = 8'b00000000; 
    reg [7:0] duty_motor_izq = 8'b00000000;
    reg [7:0] cont = 8'b00000000;
    always @(*) begin
        duty_motor_der = error + 8'd192;
        duty_motor_izq = 9'd384 - duty_motor_der;  
    end
    always @(posedge clk or negedge rst_n) begin   
        if (!rst_n) begin                           
            cont        <= 8'b00000000;
            Q_motor_der <= 1'b0;
            Q_motor_izq <= 1'b0;
        end else begin
            if (cont == 8'b11111111)
                cont <= 8'b00000000;
            else
                cont <= cont + 8'b00000001;
            if (cont < duty_motor_izq)
                Q_motor_izq <= 1'b1;
            else
                Q_motor_izq <= 1'b0;
            if (cont < duty_motor_der)
                Q_motor_der <= 1'b1;
            else
                Q_motor_der <= 1'b0;
        end
    end
endmodule
