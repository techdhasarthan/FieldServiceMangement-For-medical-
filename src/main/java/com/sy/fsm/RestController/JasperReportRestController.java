package com.sy.fsm.RestController;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.InputStream;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.sy.fsm.Model.DarDetails;
import com.sy.fsm.Model.EstimationDetails;
import com.sy.fsm.Model.MobileEstimationDetails;
import com.sy.fsm.Model.MobileOrderDetails;
import com.sy.fsm.Repository.DarDetailsRepository;
import com.sy.fsm.Repository.EstimationDetailsRepository;
import com.sy.fsm.Repository.MobileEstimationDetailsRepository;
import com.sy.fsm.Repository.MobileOrderDetailsRepository;
import com.sy.fsm.RestController.MobileRestController.OrderProductDetailsWrapper;

import net.sf.jasperreports.engine.JREmptyDataSource;
import net.sf.jasperreports.engine.JasperCompileManager;
import net.sf.jasperreports.engine.JasperExportManager;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.JasperReport;
import net.sf.jasperreports.engine.export.ooxml.JRXlsxExporter;
import net.sf.jasperreports.engine.util.JRLoader;
import net.sf.jasperreports.export.SimpleExporterInput;
import net.sf.jasperreports.export.SimpleOutputStreamExporterOutput;
import net.sf.jasperreports.export.SimpleXlsxReportConfiguration;

import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;


import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;

import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.sql.Connection;
import java.sql.Timestamp;

@org.springframework.web.bind.annotation.RestController
public class JasperReportRestController {
	
	@Autowired
	private DBController dbController;
	
	@Value("${upload.dir}")
    private String UPLOAD_DIR;
	
	@Autowired
	EstimationDetailsRepository estimationDetailsRepository;
	
	@Autowired
	DarDetailsRepository darDetailsRepository;
	
	@Autowired
	MobileEstimationDetailsRepository mobileEstimationDetailsRepository;
	
	@Autowired
	MobileOrderDetailsRepository mobileOrderDetailsRepository;
	
		
	/*private Timestamp parseTimestamp(String dateStr) {
	    if (dateStr == null || dateStr.isEmpty()) return null;
	    try {
	        return Timestamp.valueOf(dateStr);
	    } catch (IllegalArgumentException e) {
	        e.printStackTrace();
	        return null;
	    }
	}*/
	
	@GetMapping("/fsm/exportFiles/download/{filename}")
    public ResponseEntity<Resource> downloadFile(@PathVariable String filename) {
        try {
            Path file = Paths.get(UPLOAD_DIR + "/Reports/" + filename);
            Resource resource = new UrlResource(file.toUri());

            return ResponseEntity.ok()
                .contentType(MediaType.APPLICATION_OCTET_STREAM)
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + resource.getFilename() + "\"")
                .body(resource);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }
    }

	
	private Timestamp parseTimestamp(String dateStr) {
	    if (dateStr == null || dateStr.isEmpty()) {
	        return null;
	    }
	    try {
	        return Timestamp.valueOf(dateStr);
	    } catch (IllegalArgumentException e) {
	        return null; // or handle exception as needed
	    }
	}

	
	@PostMapping("/fsm/exportJasperReportInDar")
	public ResponseEntity<Map<String, String>> exportJasperReportInDar(@RequestBody String payload) {
	    Map<String, String> response = new HashMap<>();
	    try (Connection connection = dbController.getConnection()) {
	        System.out.println("/fsm/exportJasperReportInDar:::::");
	      
	        JSONObject jObj = new JSONObject(payload);
	        
	        String reportType = jObj.getString("reportType");

	        Map<String, Object> parameters = new HashMap<>();
	        parameters.put("darNo", jObj.optString("darNo", ""));
	        parameters.put("darPerformFromDate", parseTimestamp(jObj.optString("darPerformFromDate", null)));
	        parameters.put("darPerformToDate", parseTimestamp(jObj.optString("darPerformToDate", null)));
	        parameters.put("clientName", jObj.optString("clientName", ""));
	        parameters.put("clientMobileNo", jObj.optString("clientMobileNo", ""));
	        parameters.put("statusToVisit", jObj.optString("statusToVisit", ""));
	        parameters.put("createdFromDate", parseTimestamp(jObj.optString("createdFromDate", null)));
	        parameters.put("createdToDate", parseTimestamp(jObj.optString("createdToDate", null)));
	        parameters.put("createdBy", jObj.optString("createdBy", ""));
	        
	        // Main report path
	        String jasperFilePath = "/Reports/Dar_Details.jasper";
	        String settingFileName = "Dar_Report_" + System.currentTimeMillis();

	        // Load the main report
	        InputStream jasperStream = this.getClass().getResourceAsStream(jasperFilePath);
	        JasperReport jasperReport = (JasperReport) JRLoader.loadObject(jasperStream);
	        JasperPrint jasperPrint = JasperFillManager.fillReport(jasperReport, parameters, connection);

	        if (reportType.equalsIgnoreCase("pdf")) {
	            String pdfFilePath = UPLOAD_DIR + "/Reports/" + settingFileName + ".pdf";
	            JasperExportManager.exportReportToPdfFile(jasperPrint, pdfFilePath);
	            response.put("status", "true");
	            response.put("message", "PDF Report generated successfully.");
	            response.put("fileName", settingFileName + ".pdf");
	            return ResponseEntity.ok(response);
	        } else if (reportType.equalsIgnoreCase("excel")) {
	            String excelFilePath = UPLOAD_DIR + "/Reports/" + settingFileName + ".xlsx";
	            
	            JRXlsxExporter exporter = new JRXlsxExporter();
	            exporter.setExporterInput(new SimpleExporterInput(jasperPrint));
	            exporter.setExporterOutput(new SimpleOutputStreamExporterOutput(excelFilePath));

	            SimpleXlsxReportConfiguration reportConfig = new SimpleXlsxReportConfiguration();
	            reportConfig.setOnePagePerSheet(false);
	            reportConfig.setRemoveEmptySpaceBetweenRows(true);

	            exporter.setConfiguration(reportConfig);
	            exporter.exportReport();
	            response.put("status", "true");
	            response.put("message", "Excel Report generated successfully.");
	            response.put("fileName", settingFileName + ".xlsx");
	            return ResponseEntity.ok(response);
	        }

	        response.put("status", "false");
	        response.put("error", "Record not found");
	        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(response);
	    } catch (Exception e) {
	        e.printStackTrace();
	        response.put("status", "false");
	        response.put("error", "File upload failed: " + e.getMessage());
	        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
	    }
	}

	
	@SuppressWarnings("unchecked")
	@PostMapping("/fsm/exportJasperReportInEstimation")
	public ResponseEntity<Map<String, String>> exportJasperReportInEstimation(@RequestBody String payload) {
	    Map<String, String> response = new HashMap<>();
	    try {
	        JSONObject jobj = new JSONObject(payload);
	        String reportType = jobj.getString("reportType");
	        String estNo = jobj.getString("estNo");

	        // Default report path
	        String mainJasperFilePath = "/Reports/estimation_discount.jasper";
	        Optional<MobileEstimationDetails> existingRecord = mobileEstimationDetailsRepository.findByEstNo(estNo);
	        Map<String, Object> parameters = new HashMap<>();

	        if (existingRecord.isPresent()) {
	            MobileEstimationDetails estDetails = existingRecord.get();

	            // Add all parameters from MobileEstimationDetails
	            parameters.put("id", estDetails.getId().toString());
	            parameters.put("estimationProcessDate", estDetails.getEstimationProcessDate().toString());
	            parameters.put("estNO", estDetails.getEstNO());
	            parameters.put("customerName", estDetails.getCustomerName());
	            parameters.put("repAttd", estDetails.getRepAttd());
	            parameters.put("repAcc", estDetails.getRepAcc());
	            parameters.put("billingAddress", estDetails.getBillingAddress());
	            parameters.put("deliveryAddress", estDetails.getDeliveryAddress());
	            parameters.put("billingCity", estDetails.getBillingCity());
	            parameters.put("billingPin", estDetails.getBillingPin());
	            parameters.put("phone", estDetails.getPhone());
	            parameters.put("email", estDetails.getEmail());
	            parameters.put("deliveryCity", estDetails.getDeliveryCity());
	            parameters.put("deliveryPin", estDetails.getDeliveryPin());
	            parameters.put("warranty", estDetails.getWarranty());
	            parameters.put("panGst", estDetails.getPanGst());
	            parameters.put("totalProduct", estDetails.getTotalProduct());
	            parameters.put("ref", estDetails.getRef());
	            parameters.put("remarks", estDetails.getRemarks());
	            parameters.put("itsHaveDiscount", estDetails.getItsHaveDiscount());
	            parameters.put("discountEstimate", estDetails.getDiscountEstimate());
	            parameters.put("demoPieceEstimate", estDetails.getDemoPieceEstimate());
	            parameters.put("stockClearanceEstimate", estDetails.getStockClearanceEstimate());
	            parameters.put("discountAmount", estDetails.getDiscountAmount());
	            parameters.put("gst", estDetails.getGst());
	            parameters.put("deliveryCharges", estDetails.getDeliveryCharges());
	            parameters.put("totalAmount", estDetails.getTotalAmount());
	            parameters.put("registerStatus", estDetails.getRegisterStatus());
	            parameters.put("createdDate", estDetails.getCreatedDate().toString());
	            parameters.put("createdBy", estDetails.getCreatedBy());

	            mainJasperFilePath = estDetails.getItsHaveDiscount().equalsIgnoreCase("Yes")
	                                 ? "/Reports/estimation_discount.jasper"
	                                 : "/Reports/estimation_normal.jasper";
	        }
	        
	        // Load main report
	        try (InputStream mainReportStream = getClass().getResourceAsStream(mainJasperFilePath)) {
	            if (mainReportStream == null) {
	                throw new FileNotFoundException("Main report file not found: " + mainJasperFilePath);
	            }

	            JasperReport mainReport = (JasperReport) JRLoader.loadObject(mainReportStream);

	            // Get timestamp for file name
	            String timestamp = String.valueOf(System.currentTimeMillis());
	            String fileExtension = reportType.equalsIgnoreCase("pdf") ? ".pdf" : ".xlsx";
	            String filePath = UPLOAD_DIR + "/Reports/" + estNo + "_" + timestamp + fileExtension;

	            try (Connection connection = dbController.getConnection()) {
	                JasperPrint jasperPrint = JasperFillManager.fillReport(mainReport, parameters, connection);

	                if (reportType.equalsIgnoreCase("pdf")) {
	                    JasperExportManager.exportReportToPdfFile(jasperPrint, filePath);
	                } else {
	                    JRXlsxExporter exporter = new JRXlsxExporter();
	                    exporter.setExporterInput(new SimpleExporterInput(jasperPrint));
	                    exporter.setExporterOutput(new SimpleOutputStreamExporterOutput(filePath));
	                    SimpleXlsxReportConfiguration reportConfig = new SimpleXlsxReportConfiguration();
	                    reportConfig.setOnePagePerSheet(false);
	                    reportConfig.setRemoveEmptySpaceBetweenRows(true);
	                    exporter.setConfiguration(reportConfig);
	                    exporter.exportReport();
	                }

	                response.put("status", "true");
	                response.put("message", reportType.toUpperCase() + " Report generated successfully.");
	                response.put("fileName", estNo + "_" + timestamp + fileExtension);
	                return ResponseEntity.ok(response);
	            }
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	        response.put("status", "false");
	        response.put("error", "File generation failed: " + e.getMessage());
	        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
	    }
	}

	

	@SuppressWarnings("unchecked")
	@PostMapping("/fsm/exportJasperReportInOrder")
	public ResponseEntity<Map<String, String>> exportJasperReportInOrder(@RequestBody String payload) {
	    Map<String, String> response = new HashMap<>();
	    try {
	        JSONObject jobj = new JSONObject(payload);
	        String reportType = jobj.getString("reportType");
	        String estNo = jobj.getString("estNo");

	        String jasperFilePath = "Reports/fsm_order_main.jasper";        
	        Map<String, Object> parameters = new HashMap<>();
	        
	        // Retrieve the order details and set parameters
	        Optional<MobileOrderDetails> existingRecord = mobileOrderDetailsRepository.findByEstNo(estNo);
	        
	        if (existingRecord.isPresent()) {
	            MobileOrderDetails orderDetails = existingRecord.get();
	            ObjectMapper mapper = new ObjectMapper();
	            parameters = mapper.convertValue(orderDetails, Map.class);
	        }
	        
	        // Load the main report
	        try (InputStream jasperStream = getClass().getClassLoader().getResourceAsStream(jasperFilePath)) {
	            if (jasperStream == null) {
	                throw new FileNotFoundException("Main report file not found: " + jasperFilePath);
	            }

	            JasperReport jasperReport = (JasperReport) JRLoader.loadObject(jasperStream);
	            JasperPrint jasperPrint = JasperFillManager.fillReport(jasperReport, parameters, new JREmptyDataSource());

	            String fileExtension = reportType.equalsIgnoreCase("pdf") ? ".pdf" : ".xlsx";
	            String filePath = UPLOAD_DIR + "/Reports/" + estNo + "_" + System.currentTimeMillis() + fileExtension;

	            if (reportType.equalsIgnoreCase("pdf")) {
	                JasperExportManager.exportReportToPdfFile(jasperPrint, filePath);
	            } else {
	                JRXlsxExporter exporter = new JRXlsxExporter();
	                exporter.setExporterInput(new SimpleExporterInput(jasperPrint));
	                exporter.setExporterOutput(new SimpleOutputStreamExporterOutput(filePath));
	                SimpleXlsxReportConfiguration reportConfig = new SimpleXlsxReportConfiguration();
	                reportConfig.setOnePagePerSheet(false);
	                reportConfig.setRemoveEmptySpaceBetweenRows(true);
	                exporter.setConfiguration(reportConfig);
	                exporter.exportReport();
	            }

	            response.put("status", "true");
	            response.put("message", reportType.toUpperCase() + " Report generated successfully.");
	            response.put("fileName", estNo + "_" + System.currentTimeMillis() + fileExtension);
	            return ResponseEntity.ok(response);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	        response.put("status", "false");
	        response.put("error", "File generation failed: " + e.getMessage());
	        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
	    }
	}





}
