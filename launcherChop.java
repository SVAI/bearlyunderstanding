import clevage.Cleavage;
import util.FileHelp;

import java.io.File;
import java.io.FileNotFoundException;
import java.net.URISyntaxException;

/**
 * Created by wwang on 10/19/16.
 */
public class launcherChop {

    static public void main(String[] args) throws URISyntaxException {
        Cleavage cl = new Cleavage();
//        if(args.length != 2){
//            System.out.println("Invalid parameter. Need two input files.");
//            return;
//        }
//        try {
//            cl.run(new File(args[0]), new File(args[1]));
//        } catch (FileNotFoundException e) {
//            e.printStackTrace();
//        }

        //find file pairs
        String metaPath = FileHelp.getMetaFilePath();
        File folder = new File(metaPath);
        File[] listOfMetaFiles = folder.listFiles();

        String affPath = FileHelp.getChopFilePath();
        folder = new File(affPath);
        File[] listOfAffFiles = folder.listFiles();
        for (int i = 0; i < listOfAffFiles.length; i++) {
            if (listOfAffFiles[i].isFile()) {
                for(int j = 0; j< listOfMetaFiles.length; j++){
                    if(isMatch(listOfAffFiles[i].getName(), listOfMetaFiles[j].getName())){
                        System.out.println(listOfMetaFiles[j].getName() +" "+listOfAffFiles[i].getName());
                        try {
                            cl.run(listOfMetaFiles[j], listOfAffFiles[i]);
                        } catch (FileNotFoundException e) {
                            System.out.println("Can't find file");
                            e.printStackTrace();
                        }
                    }
                }
            }
        }



    }

    static boolean isMatch(String name1, String name2){
        String[] name1List = name1.split("_");
        String[] name2List = name2.split("_");
        return name1List[0].equals(name2List[0]) && name1List[1].equals(name2List[1]);
    }


}
