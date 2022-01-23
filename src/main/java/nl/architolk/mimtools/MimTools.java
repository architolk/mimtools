package nl.architolk.mimtools;

import java.io.File;
import java.io.FileFilter;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.IOException;
import org.apache.commons.io.FilenameUtils;
import org.apache.commons.io.filefilter.WildcardFileFilter;
import org.apache.jena.graph.Factory;
import org.apache.jena.query.Dataset;
import org.apache.jena.query.DatasetFactory;
import org.apache.jena.rdf.model.Model;
import org.apache.jena.rdf.model.ModelFactory;
import org.apache.jena.rdf.model.RDFWriterI;
import org.apache.jena.rdf.model.Resource;
import org.apache.jena.riot.Lang;
import org.apache.jena.riot.RDFDataMgr;
import org.apache.jena.riot.RiotException;
import org.apache.jena.util.FileUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.topbraid.shacl.validation.ValidationUtil;

public class MimTools {

  private static final Logger LOG = LoggerFactory.getLogger(MimTools.class);

  private static String BASE_URI = "http://dotwebstack.org/validator";

  private static void loadFiles(Model model, String filter) throws FileNotFoundException {

    File path = new File(filter);
    File dir = new File(path.getParent());
    FileFilter fileFilter = new WildcardFileFilter(path.getName());
    File[] files = dir.listFiles(fileFilter);
    for (File file : files) {
      LOG.info(String.format("Loading file: %s",file.toString()));
      String ext = FilenameUtils.getExtension(file.toString());
      if (ext.equals("trig")) {
        // Trig files contain multiple names graph.
        // We combine those graphs, and add them to the model
        Dataset ds = DatasetFactory.create();
        RDFDataMgr.read(ds, new FileInputStream(file), BASE_URI, Lang.TRIG);
        model.add(ds.getUnionModel());
        ds.close();
      } else {
        model.read(new FileInputStream(file), BASE_URI, ext);
      }
    }

  }

  private static void writeModel(Model model, String fileName) throws IOException {

    FileWriter writer = new FileWriter(fileName);
    RDFWriterI w = model.getWriter(FileUtils.langTurtle);
    w.write(model, writer, BASE_URI);
    writer.close();
    LOG.info(String.format("Reported to file: %s",fileName));
  }

  public static void main(String[] args) {

    if (args.length == 2) {

      LOG.info("Truncating data graphs into single model");
      LOG.info(String.format("File(s) containing the data graph: %s",args[0]));

      try {
        Model dataModel = ModelFactory.createModelForGraph(Factory.createDefaultGraph());

        // Load the data model
        LOG.info("Loading data files");
        loadFiles(dataModel, args[0]);

        // Write truncated data model
        writeModel(dataModel,args[1]);

      } catch (IOException e) {
        LOG.error(e.getMessage());
      } catch (RiotException e) {
        //Already send to output via SLF4J
      }
    } else if (args.length == 4) {

      LOG.info("Starting the validator");
      LOG.info(String.format("File(s) containing the data graph: %s",args[0]));
      LOG.info(String.format("File(s) containing the ontology graph: %s",args[1]));
      LOG.info(String.format("File(s) containing the shapes graph: %s",args[2]));

      try {
        Model dataModel = ModelFactory.createModelForGraph(Factory.createDefaultGraph());

        // Load the data model
        LOG.info("Loading data files");
        loadFiles(dataModel, args[0]);

        // Load the ontology model into the data model
        LOG.info("Loading ontology files");
        loadFiles(dataModel, args[1]);

        // Load the shapes model
        Model shapesModel = ModelFactory.createModelForGraph(Factory.createDefaultGraph());
        LOG.info("Loading shape files");
        loadFiles(shapesModel, args[2]);

        // Perform the validation of everything, using the data model
        LOG.info("Start validation");
        Resource report = ValidationUtil.validateModel(dataModel, shapesModel, true);

        // Write violations
        writeModel(report.getModel(),args[3]);

      } catch (IOException e) {
        LOG.error(e.getMessage());
      } catch (RiotException e) {
        //Already send to output via SLF4J
      }
    } else {

      LOG.error("Usage:");
      LOG.error("(1) validator "
          + "data-graph-file ontology-graph-file shapes-graph-file report-file");
      LOG.error("(2) validator data-graph-file truncated-data-file");
      LOG.error("Wildcards are allowed for input parameters");
      LOG.error("Example: \"vocabulary/examples/*.trig\" \"vocabulary/elmo/*.ttl\" "
          + "\"vocabulary/elmo-shacl.ttl\" \"validator/report.ttl\"");
    }
  }
}
