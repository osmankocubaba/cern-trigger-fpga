`timescale 1ns / 1ps

module trigger_unit (
    input  wire        clk,          // Sistem saat sinyali
    input  wire        rst_n,        // Asenkron aktif-düşük sıfırlama (reset)
    input  wire [15:0] adc_data,     // Parçacık dedektöründen gelen 16-bit veri
    input  wire [15:0] threshold,    // Enerji/gerilim eşik değeri
    output reg         trigger_out,  // Tetikleme sinyali (1: Önemli çarpışma tespit edildi)
    output reg  [31:0] event_counter // Kaydedilen toplam parçacık olayı sayısı
);

    // Saat darbesiyle çalışan ardışıl mantık (Sequential Logic)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            trigger_out   <= 1'b0;
            event_counter <= 32'd0;
        end else begin
            // Dedektör sinyali eşik değerini aştığında tetik üret
            if (adc_data >= threshold) begin
                trigger_out   <= 1'b1;
                event_counter <= event_counter + 1'b1;
            end else begin
                trigger_out   <= 1'b0;
            end
        end
    end

endmodule