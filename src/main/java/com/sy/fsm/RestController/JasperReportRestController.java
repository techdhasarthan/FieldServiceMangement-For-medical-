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
import com.sy.fsm.Repository.DarDetailsRepository;
import com.sy.fsm.Repository.EstimationDetailsRepository;

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

	@PostMapping("/fsm/exportJasperReportInEstimation")
	public ResponseEntity<Map<String, String>> exportJasperReportInEstimation(@RequestBody String payload) {
	    Map<String, String> response = new HashMap<>();
	    try {
	        JSONObject jobj = new JSONObject(payload);
	        String reportType = jobj.getString("reportType");
	        String estNo = jobj.getString("estNo");

	        // Default report paths
	        String mainJasperFilePath = "/Reports/estimation_discount.jasper";
	        Optional<EstimationDetails> existingRecord = estimationDetailsRepository.findByEstNo(estNo);
	        
	        if (existingRecord.isPresent()) {
	            EstimationDetails estDetails = existingRecord.get();
	            mainJasperFilePath = estDetails.getItsHaveDiscount().equalsIgnoreCase("Yes")
	                                 ? "/Reports/estimation_discount.jasper"
	                                 : "/Reports/estimation_normal.jasper";
	        }

	        Map<String, Object> parameters = new HashMap<>();
	        parameters.put("estNo", estNo);

	        // Set subreport directory
	        String subReportDir = getClass().getResource("/Reports/").getPath();
	        parameters.put("SUBREPORT_DIR", subReportDir); // Set the path for sub-reports

	        // Load main and subreports
	        try (InputStream mainReportStream = getClass().getResourceAsStream(mainJasperFilePath);
	             InputStream subReportStream = getClass().getResourceAsStream("estimation_product.jasper")) {

	            if (mainReportStream == null) {
	                throw new FileNotFoundException("Main report file not found: " + mainJasperFilePath);
	            }
	            if (subReportStream == null) {
	                throw new FileNotFoundException("Sub-report file not found: /Reports/estimation_product.jasper");
	            }

	            // Load main report (either compiled .jasper or .jrxml)
	            JasperReport mainReport = (JasperReport) JRLoader.loadObject(mainReportStream);
	            JasperReport subReport = (JasperReport) JRLoader.loadObject(subReportStream);

	            // Put the sub-report into parameters map (optional since we're using SUBREPORT_DIR)
	            parameters.put("estimation_product", subReport); // Not needed if using SUBREPORT_DIR

	            // Fill the main report
	            try (Connection connection = dbController.getConnection()) {
	                JasperPrint jasperPrint = JasperFillManager.fillReport(mainReport, parameters, connection);
	                
	                // Determine file extension and path
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
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	        response.put("status", "false");
	        response.put("error", "File generation failed: " + e.getMessage());
	        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
	    }
	}



	
/*@PostMapping("/fsm/exportJasperReportInEstimation")
	public ResponseEntity<Map<String, String>> exportJasperReportInEstimation(@RequestBody String payload) {
	    Map<String, String> response = new HashMap<>();
	    try {
	        System.out.println("/fsm/exportJasperReportInEstimation:::::");
	        JSONObject jobj = new JSONObject(payload);

	        String reportType = jobj.getString("reportType");
	        String estNo = jobj.getString("estNo");

	        // Determine the main Jasper file path based on itsHaveDiscount
	        String jasperFilePath = "Reports/estimation_discount.jasper";
	        Optional<EstimationDetails> existingRecord = estimationDetailsRepository.findByEstNo(estNo);
	        if (existingRecord.isPresent()) {
	            System.out.println("existingRecord found");
	            EstimationDetails estDetails = existingRecord.get();
	            jasperFilePath = estDetails.getItsHaveDiscount().equalsIgnoreCase("Yes")
	                             ? "Reports/estimation_discount.jasper"
	                             : "Reports/estimation_normal.jasper";
	        }

	        Map<String, Object> parameters = new HashMap<>();
	        parameters.put("estNo", estNo);

	        // Load the main report
	        try (InputStream mainReportStream = getClass().getClassLoader().getResourceAsStream(jasperFilePath)) {
	            if (mainReportStream == null) {
	                throw new FileNotFoundException("Main report file not found: " + jasperFilePath);
	            }

	            JasperReport mainReport = (JasperReport) JRLoader.loadObject(mainReportStream);

	            // Get the database connection
	            try (Connection connection = dbController.getConnection()) {
	                JasperPrint jasperPrint = JasperFillManager.fillReport(mainReport, parameters, connection);

	                // Set the file extension and path for export
	                String fileExtension = reportType.equalsIgnoreCase("pdf") ? ".pdf" : ".xlsx";
	                String fileName = estNo + "_" + System.currentTimeMillis() + fileExtension;
	                String filePath = UPLOAD_DIR + "/Reports/" + fileName;

	                // Export the report
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

	                // Prepare response
	                response.put("status", "true");
	                response.put("message", reportType.toUpperCase() + " Report generated successfully.");
	                response.put("fileName", fileName);
	                System.out.println("Export Report Successfully");

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
*/

	
	
	@PostMapping("/fsm/exportJasperReportInOrder")
	public ResponseEntity<Map<String, String>> exportJasperReportInOrder(@RequestBody String payload) {
	    Map<String, String> response = new HashMap<>();
	    try {
	        System.out.println("/fsm/exportJasperReportInOrder:::::");
	        JSONObject jobj = new JSONObject(payload);

	        String reportType = jobj.getString("reportType");
	        String estNo = jobj.getString("estNo");
	       
	        String jasperFilePath = "Reports/fsm_order_main.jasper";	        

	        Map<String, Object> parameters = new HashMap<>();
	        parameters.put("estNo", estNo);
	   
	        File reportsDir = new File("src/main/resources/Reports/");
	        if (!reportsDir.exists()) {
	            throw new FileNotFoundException("Reports directory not found.");
	        }
	        parameters.put("SUBREPORT_DIR", reportsDir.getAbsolutePath() + File.separator);	        
	        String settingFileName = estNo + "_" + System.currentTimeMillis();
	        try (InputStream jasperStream = getClass().getClassLoader().getResourceAsStream(jasperFilePath)) {
	            if (jasperStream == null) {
	                throw new FileNotFoundException("Main report file not found: " + jasperFilePath);
	            }
	            JasperReport jasperReport = (JasperReport) JRLoader.loadObject(jasperStream);
	            JasperPrint jasperPrint = JasperFillManager.fillReport(jasperReport, parameters, new JREmptyDataSource());

	            String fileExtension = reportType.equalsIgnoreCase("pdf") ? ".pdf" : ".xlsx";
	            String filePath = UPLOAD_DIR + "/Reports/" + settingFileName + fileExtension;

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
	            response.put("fileName", settingFileName + fileExtension);
	            System.out.println("Export Report Successfully");
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
