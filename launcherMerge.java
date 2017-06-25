import analysis.GenerateOutput;
import analysis.MergeTool;
import analysis.ProcessVcf;
import databaseAccess.DatabaseUtil;
import util.FileHelp;

import java.io.File;
import java.net.URISyntaxException;


/**
 * Created by wwang on 9/5/16.
 */
public class launcherMerge {

    static public void main(String[] args) throws URISyntaxException {

        DatabaseUtil.connectDatabase();

        if(args.length != 2){
            System.out.println("please enter two input files and one output file");
            DatabaseUtil.cleanUp();
            return;
        }
        MergeTool mt = new MergeTool();
        //File input1 = new File(args[0]);
        //File input2 = new File(args[1]);

        //find file pairs
        String fpPath = FileHelp.getFpPath();
        File folder = new File(fpPath);
        File[] listOfFpFiles = folder.listFiles();

        String fnPath = FileHelp.getFnPath();
        folder = new File(fnPath);
        File[] listOfFnFiles = folder.listFiles();
        for (int i = 0; i < listOfFpFiles.length; i++) {
            if (listOfFpFiles[i].isFile()) {
                for(int j = 0; j< listOfFnFiles.length; j++){
                    if(isMatch(listOfFpFiles[i].getName(), listOfFnFiles[j].getName())){
                        System.out.println(listOfFpFiles[i].getName()+"  "+listOfFnFiles[j].getName());

                            File input1 = listOfFpFiles[i];
                            File input2 = listOfFnFiles[j];
                        String name = input1.getName();
                        if(name.split("\\.")[0].isEmpty()){
                            continue;
                        }
                            if(input1.getName().length() < 3 || input2.getName().length() < 3){
                                System.out.println("invalid input file name");
                                DatabaseUtil.cleanUp();
                                return;
                            }
                            int start = 2;
                            int end = start;
                            String inputName = input1.getName();

                            for(int m = start; m< inputName.length(); m++){
                                if(Character.isDigit(inputName.charAt(m))){
                                    continue;
                                }else {
                                    end = m;
                                    break;
                                }
                            }

                            String outputName = inputName.substring(0, end);
                            File output = new File(FileHelp.getOutput() + outputName+".txt");
                            mt.merge(input1, input2, output);
                            ProcessVcf pv = new ProcessVcf();
                            pv.run(output);

                            GenerateOutput go = new GenerateOutput();
                            go.run(pv.geneList, outputName, true);
                        }
                }
            }
        }


        DatabaseUtil.cleanUp();

    }

    static boolean isMatch(String name1, String name2){
        String[] name1List = name1.split("_");
        String[] name2List = name2.split("_");
        return name1List[0].equals(name2List[0]) && name1List[1].equals(name2List[1]);
    }
}
