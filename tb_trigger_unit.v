`timescale 1ns / 1ps

module tb_trigger_unit();

    // Devreye bağlanacak sanal sinyaller
    reg         clk;
    reg         rst_n;
    reg  [15:0] adc_data;
    reg  [15:0] threshold;

    // Devrenin üreteceği sonuçları izleyeceğimiz sinyaller
    wire        trigger_out;
    wire [31:0] event_counter;

    // Dosya okuma değişkenleri
    integer file_handle;
    integer scan_status;
    reg [15:0] read_val;

    // Test edilecek devre modülümüz (DUT - Device Under Test)
    trigger_unit uut (
        .clk(clk),
        .rst_n(rst_n),
        .adc_data(adc_data),
        .threshold(threshold),
        .trigger_out(trigger_out),
        .event_counter(event_counter)
    );

    // 100 MHz sanal saat sinyali (Periyot = 10 ns: 5 ns '0', 5 ns '1')
    always #5 clk = ~clk;

    // Test senaryosu
    initial begin
        // Başlangıç değerleri
        clk = 0;
        rst_n = 0;
        adc_data = 16'd0;
        threshold = 16'd2000; // Eşik değerimiz: 2000 ADC sayımı

        // 20 ns reset durumunda tut, sonra devreyi başlat
        #20;
        rst_n = 1;

        // Python tarafından üretilen dedektör veri akışını aç
        file_handle = $fopen("detector_stream.txt", "r");
        if (file_handle == 0) begin
            $display("HATA: detector_stream.txt dosyasi bulunamadi!");
            $finish;
        end

        // Dosya bitene kadar her saat darbesinde bir satır oku ve devreye ver
        while (!$feof(file_handle)) begin
            @(posedge clk);
            scan_status = $fscanf(file_handle, "%d\n", read_val);
            adc_data <= read_val;
        end

        // Dosyayı kapat ve simülasyonu sonlandır
        $fclose(file_handle);
        #100;
        $finish;
    end

endmodule