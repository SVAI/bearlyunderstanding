import analysis.ProcessAff;
import util.FileHelp;

import java.io.File;
import java.io.FileNotFoundException;
import java.net.URISyntaxException;

/**
 * Created by wwang.
 */
public class laucherAff {
    static public void main(String[] args) throws URISyntaxException {
        ProcessAff pa = new ProcessAff();
      //  pa.run(new File("/Users/wwang/IdeaProjects/MiHAIP/output/chopMeta/n_177_protien.txt"), new File("/Users/wwang/IdeaProjects/MiHAIP/aff/n_177_C0702.txt"));

        String metaPath = FileHelp.getChopMetaPath();
        File folder = new File(metaPath);
        File[] listOfMetaFiles = folder.listFiles();

        String affPath = "/Users/wwang/IdeaProjects/MiHAIP/aff/";
        folder = new File(affPath);
        File[] listOfAffFiles = folder.listFiles();
        for (int i = 0; i < listOfAffFiles.length; i++) {
            if (listOfAffFiles[i].isFile()) {
                for(int j = 0; j< listOfMetaFiles.length; j++){
                    if(isMatch(listOfAffFiles[i].getName(), listOfMetaFiles[j].getName())){
                        System.out.println(listOfMetaFiles[j].getName() +" "+listOfAffFiles[i].getName());
                        pa.run(listOfMetaFiles[j], listOfAffFiles[i]);
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
