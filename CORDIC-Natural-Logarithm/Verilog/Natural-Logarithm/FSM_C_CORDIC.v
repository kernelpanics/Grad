`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Tecnológico de Costa Rica
// Engineer: Juan José Rojas Salazar 
// 
// Create Date: 30.07.2016 10:22:05 
// Design Name: 
// Module Name: FSM_C_CORDIC
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
//////////////////////////////////////////////////////////////////////////////////

module FSM_C_CORDIC(
     //INPUTS
     input wire CLK,             //system clock
     input wire RST_LN,          //system reset 
     input wire ACK_ADD_SUBTX,   //RECIBE SI LA SUMA EN FLOTANTE X SE EJECUTO 
     input wire ACK_ADD_SUBTY,   //RECIBE SI LA SUMA EN FLOTANTE Y SE EJECUTO
     input wire ACK_ADD_SUBTZ,   //RECIBE SI LA SUMA EN FLOTANTE Z SE EJECUTO 
     input wire Begin_FSM_LN,    //inicia la maquina de estados 
     input wire [4:0] CONT_ITER, //LLEVA LA CUENTA DE LA ITERACIONES 
    
     //OUTPUT SIGNALS
     output reg RST,             //REALIZA EL RESET DE LOS REGISTROS 
     output reg MS_1,            //SELECCION DEL MUX 1 
     output reg EN_REG3,         //ENABLE PARA EL REGISTRO 3 CON EL VALOR INICIAL DE T ESCALADO POR 16
     output reg EN_REG4,         //ENABLE PARA EL REG 4 DEL RESULTADO FINAL 
     output reg ADD_SUBT,        //SELECCION DE OPERACION PARA EL ADD/SUBT FLOTANTE 
     output reg Begin_SUMX,      //INICIA ADD/SUM FLOTANTE X
     output reg Begin_SUMY,      //INICIA ADD/SUM FLOTANTE Y
     output reg Begin_SUMZ,      //INICIA ADD/SUM FLOTANTE Z 
     output reg EN_REG1X,        //ENABLE PARA EL REGISTRO X DE LA PRIMERA ETAPA 
     output reg EN_REG1Y,        //ENABLE PARA EL REGISTRO Y DE LA PRIMERA ETAPA
     output reg EN_REG1Z,        //ENABLE PARA EL REGISTRO Z DE LA PRIMERA ETAPA 
     output reg MS_2,            //SELECCION DEL MUX 2
     output reg MS_3,            //SELECCION DEL MUX 3
     output reg EN_REG2,         //ENABLE PARA EL REGISTRO CON LOS VALORES DESPLAZADOS DE LA SEGUNDA ETAPA 
     output reg CLK_CDIR,        //CLK PARA EL CONTADOR DE ITERACIONES 
     output reg EN_REG2XYZ,      //ENABLE PARA EL VALOR ANTERIOR DE XYZ DE SEGUNDA ETAPA 
     output reg ACK_LN,          //ACK PARA SABER SI LA OPERACION LN YA SE REALIZO 
    
     //REGISTROS DE SELECTORES
     output reg EN_ADDSUBT,
     output reg EN_MS1,
     output reg EN_MS2,
     output reg EN_MS3
	 );

parameter [5:0] //se definen los estados que se utilizaran en la maquina
     a = 6'd0,
     b = 6'd1,
     c = 6'd2,
     d = 6'd3,
     e = 6'd4,
     f = 6'd5,
     g = 6'd6, 
     h = 6'd7,   
     i = 6'd8,
     j = 6'd9, 
     k = 6'd10,                          
     l = 6'd11,  
     m = 6'd12,
     n = 6'd13,
     o = 6'd14,
     p = 6'd15,
     q = 6'd16,
     r = 6'd17,
     s = 6'd18,
     t = 6'd19;
					
reg [5:0] state_reg, state_next ; //state registers declaration

always @(posedge CLK, posedge RST_LN)
	
	if (RST_LN) begin
		state_reg <= a;	
	end
	
	else begin
		state_reg <= state_next;
	end

///	
always @*
    begin
    state_next = state_reg;
	
    EN_REG2 = 0;
    EN_REG3 = 0;
    EN_REG4 = 0;
    EN_REG1X = 0;
    EN_REG1Y = 0;
    EN_REG1Z = 0;
    EN_REG2XYZ = 0;
    Begin_SUMX = 0;
    Begin_SUMY = 0;
    Begin_SUMZ = 0;
    ACK_LN = 0;
    CLK_CDIR = 0;
    RST = 0;
    MS_1 = 0;
    MS_2 = 0;
    MS_3 = 0;   
    ADD_SUBT = 0;
    EN_ADDSUBT = 0;
    EN_MS1 = 0;
    EN_MS2 = 0;
    EN_MS3 = 0;
    //nuevos estados 
      
case(state_reg)
            a: 
            begin            
                if(Begin_FSM_LN) 
                    begin
                    RST = 1; 
                    state_next = b;
                    end
                else
                    state_next = a;
            end
            
            b:
            begin
                MS_1 = 1;
                EN_MS1 = 1;
                MS_2 = 1;
                EN_MS2 = 1;
                MS_3 = 0;
                EN_MS3 = 1;  
                ADD_SUBT = 0;
                EN_ADDSUBT = 1;
                state_next = c;
            end
                   
            c:
            begin
                EN_REG3 = 1;
                state_next = d;
            end
        
            d:
            begin
                Begin_SUMX = 1;
                Begin_SUMY = 1;      
                state_next = e;
            end
            
            e:
            begin
                state_next = f;
            end
            
            f:
            begin
                if(ACK_ADD_SUBTX && ACK_ADD_SUBTY )
                    begin 
                    EN_REG1X = 1;
                    EN_REG1Y = 1;
                    EN_REG1Z = 1;
                    MS_1 = 0;
                    EN_MS1 = 1;
                    MS_2 = 0;
                    EN_MS2 = 1;
                    state_next = g;
                    end
                else
                    state_next = f;
            end
                                                  
            g:
            begin
                EN_REG2 = 1;
                state_next = h;
            end
            
            h:
            begin
                EN_REG2XYZ = 1;
                state_next = i;
            end
                             
            i:
            begin           
                Begin_SUMX = 1;
                Begin_SUMZ = 1;
                CLK_CDIR = 1;
                state_next = j;
            end
            
            j:
            begin
                state_next = k;
            end
            
            k:
            begin   
                    Begin_SUMY = 1;
                if(ACK_ADD_SUBTX && ACK_ADD_SUBTZ)
                    begin
                    EN_REG1X = 1;
                    EN_REG1Z = 1;
                    state_next = l;
                    end
                else
                    state_next = k;
            end
                     
            l:
            begin
                if(ACK_ADD_SUBTY)
                    begin
                    EN_REG1Y = 1;
                    state_next = m;
                    end
                else
                    state_next = l;
            end 
                                            
            m:
            begin                       
                if(CONT_ITER == 5'b01111) //15 iteraciones
                    begin 
                    MS_3 = 1;
                    EN_MS3 = 1;
                    ADD_SUBT = 0;
                    EN_ADDSUBT = 1; 
                    state_next = n;
                    end
                else
                   state_next = g;
            end      
            
            n:
            begin
               Begin_SUMZ = 1;
               state_next = o;
            end          
            
            o:
            begin           
               if(ACK_ADD_SUBTZ)
                  begin 
                  EN_REG4 = 1;
                  state_next = p;
                  end
               else
                  state_next = o;
            end 
     
            p:
            begin
                ACK_LN = 1;
                if(RST_LN)
                    begin 
                    RST = 1; 
                    state_next = a;
                    end
            end
            
       default:
       state_next=a;
       endcase
    end
	
endmodule	
