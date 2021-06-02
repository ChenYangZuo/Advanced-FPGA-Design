module spdif(
    output reg oDatavalidL, oDatavalidR,
    output reg [23:0] oDataL, oDataR,
    inout iRst,
    input iClk,
    input iSPDIFin);

    reg [2:0] inputsr;
    reg datatoggle;
    reg [9:0] pulsewidthcnt;
    reg [9:0] pulsewidth;
    reg [9:0] onebitwidth;
    reg pulsewidthvalid;
    reg bitonedet;
    reg newbitreg;
    reg [27:0] framecapture;
    reg preambledetect;
    reg preamblesyncen;
    reg channelsel;
    reg [5:0] bitnum;
    reg [10:0] onebitwidth1p5;
    reg onebitload;
    reg onebitupdown;
    reg [9:0] pulsewidthcomp;
    reg onebitgood;
    reg preamblesync;
    reg shiftnewdat;
    reg outputload,outputloadprev;
    reg pulsewidthsmall, pulsewidthlarge;
    reg [11:0] onebitwidth2p5;
    wire trigviolation;
    wire newbit;

    assign trigviolation = {1'b0,pulsewidth[9:0],1'b0} > onebitwidth2p5;
    assign newbit = ({pulsewidth[9:0],1'b0} < onebitwidth1p5[10:0]);

    always @(posedge iClk or posedge iRst) begin
        if(iRst) begin
            inputsr <= 0;
            datatoggle <= 0;
            pulsewidthcnt <= 0;
            pulsewidth <= 0;
            onebitwidth <= 0;
            pulsewidthvalid <= 0;
            bitonedet <= 0;
            newbitreg <= 0;
            framecapture <= 0;
            preambledetect <= 0;
            preamblesyncen <= 0;
            channelsel <= 0;
            bitnum <= 0;
            onebitwidth1p5 <= 0;
            onebitload <= 0;
            onebitupdown <= 0;
            pulsewidthcomp <= 0;
            onebitgood <= 0;
            preamblesync <= 0;
            shiftnewdat <= 0;
            outputload <= 0;
            outputloadprev <= 0;
            pulsewidthsmall <= 0;
            pulsewidthlarge <= 0;
            onebitwidth2p5 <= 0;
        end
        else begin
            inputsr <= {inputsr[1:0],iSPDIFin};
            datatoggle <= inputsr[2]^inputsr[1];
            if(datatoggle) begin
                pulsewidth[9:0] <= pulsewidthcnt[9:0];
                pulsewidthcnt <= 2;
            end
            else
                pulsewidthcnt <= pulsewidthcnt + 2;
            pulsewidthvalid <= datatoggle;
            pulsewidthsmall <= ({1'b0,onebitwidth[9:1]}>pulsewidth[9:0]);
            pulsewidthlarge <= ({2'b0,pulsewidth[9:2]}>onebitwidth);
            onebitload <= pulsewidthlarge || pulsewidthsmall;
            if(!newbit)
                pulsewidthcomp <= {1'b0,pulsewidth[9:1]};
            else
                pulsewidthcomp <= pulsewidth[9:0];
            onebitgood <= (pulsewidthcomp == onebitwidth);
            onebitupdown <= (pulsewidthcomp>onebitwidth);
            if(onebitload)
                onebitwidth <= pulsewidth[9:0];
            else if(!onebitgood && pulsewidthvalid) begin
                if(onebitupdown)
                    onebitwidth <= onebitwidth+1;
                else
                    onebitwidth <= onebitwidth-1;
            end
            onebitwidth1p5 <= ({onebitwidth[9:0],1'b0}+{1'b0,onebitwidth[9:0]});
            onebitwidth2p5 <= ({onebitwidth[9:0],2'b0}+{2'b0,onebitwidth[9:0]});
            preamblesyncen <= (bitnum == 0)&&datatoggle;
            preamblesync <= preamblesyncen && trigviolation;
            if(preamblesync)
                preambledetect <= 1;
            else if(preambledetect && pulsewidthvalid)
                preambledetect <= 0;
            if(preambledetect && pulsewidthvalid)
                channelsel <= !trigviolation;
            else if(trigviolation && pulsewidthvalid)
                channelsel <= 0;
            newbitreg <= newbit;
            if(!newbitreg)
                bitonedet <= 0;
            else if(newbit && datatoggle)
                bitonedet <= !bitonedet;
            shiftnewdat <= pulsewidthvalid && (!newbit||bitonedet);
            if(shiftnewdat)
                framecapture[27:0] <= {newbit,framecapture[27:1]};
            if(outputload)
                bitnum <= 0;
            else if(preamblesync)
                bitnum <= 1;
            else if(shiftnewdat && (bitnum != 0))
                bitnum <= bitnum + 1;
            outputload <= (bitnum == 31);
            outputloadprev <= outputload;
            if(outputload & !outputloadprev) begin
                if(channelsel) begin
                    oDataR <=  framecapture[23:0];
                    oDatavalidR <= 1;
                end
                else begin
                    oDataL <=  framecapture[23:0];
                    oDatavalidL <= 1;
                end
            end
            else begin
                oDatavalidR <= 0;
                oDatavalidL <= 0;
            end
        end
    end
endmodule 