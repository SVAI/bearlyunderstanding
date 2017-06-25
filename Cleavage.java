package clevage;

import util.FileHelp;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.PrintWriter;
import java.net.URISyntaxException;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

/**
 * Created by wwang on 10/16/16.
 */
public class Cleavage {
    ArrayList<Integer> location = new ArrayList<>();
    ArrayList<String>  headerData = new ArrayList<>();
    ArrayList<PairData> dataList = new ArrayList<>();
    Scanner sn;
    PrintWriter pw;
    PrintWriter chopMetaWriter;
    public void run(File meta, File input) throws FileNotFoundException {
        String [] list = input.getName().split("\\.");
        String fileName = list[0];
        if(fileName.isEmpty()){
            return;
        }
        try {
            pw = new PrintWriter(new File(FileHelp.getChopDiffPath() + fileName + "_result.txt"));
            chopMetaWriter = new PrintWriter(new File(FileHelp.getChopMetaPath() + fileName + ".txt"));
        } catch (URISyntaxException e) {
            e.printStackTrace();
            return;
        }
        loadMetaData(meta);

        sn = new Scanner(input);
        findPair();
        generateOutput();

        sn.close();
        pw.close();
        chopMetaWriter.close();

        dataList.clear();
        location.clear();
        headerData.clear();
    }

    private void generateOutput() {
        if(location.size()== dataList.size()){
            for(int i = 0; i < location.size(); i++){
                processOneLocation(location.get(i), dataList.get(i), i);
            }
        }
    }

    private void processOneLocation(Integer index, PairData pairData, int i) {
        if(pairData.seq1.equals(pairData.seq2)){
            return;
        }
        List<String>  result1 = clevage(index, pairData.seq1, pairData.cle1);
        List<String>  result2 = clevage(index, pairData.seq2, pairData.cle2);

        List<String> noRepeat1 = removeRepeat(result1, result2);
        List<String> noRepeat2 = removeRepeat(result2, result1);

        for(String fragment : noRepeat1){
            pw.println(">" + pairData.id + "|D");
            pw.println(fragment);
            chopMetaWriter.println(headerData.get(i));
        }

        for(String fragment : noRepeat2){
            pw.println(">" + pairData.id + "|R");
            pw.println(fragment);
            chopMetaWriter.println(headerData.get(i));
        }

    }

    private String getListString(List<String> noRepeat1) {
        StringBuilder sb = new StringBuilder();
        for(String s : noRepeat1){
            sb.append(",");
            sb.append(s);
        }
        if(sb.length() > 0){
            sb.deleteCharAt(0);
        }
        return sb.toString();
    }

    private List<String> removeRepeat(List<String> data, List<String> ref) {
        List<String> noRepeat = new ArrayList<>();
        for(String s : data){
            boolean repeat = false;
            for(String r : ref){
                if(s.equals(r)){
                    repeat = true;
                }
            }
            if(!repeat){
                noRepeat.add(s);
            }
        }
        return noRepeat;
    }

    private List<String> clevage(Integer index, String seq1, String cle1) {
        List<String> result = new ArrayList<>();
        List<Integer> maker = new ArrayList<>();
        for(int i = 0 ; i < cle1.length(); i++){
            if(cle1.charAt(i) == 'S'){
                maker.add(i);
            }
        }
        for(int i = 0; i< maker.size(); i++){
            for(int j = i+1; j< maker.size(); j++){
                int size = maker.get(j) - maker.get(i) + 1;
                if(size >= 8 && size <= 10){
                    if(index >= maker.get(i) && index <= maker.get(j)){
                        result.add(seq1.substring(maker.get(i), maker.get(j)+1));
                    }
                }else {
                    if(size > 10){
                        break;
                    }
                }
            }
        }
        return result;
    }

    private void findPair() {
        String id = null;
        String seq1 = null;
        String cle1 = null;

        String seq2 = null;
        String cle2 = null;

        while (sn.hasNext()){
            String line = sn.nextLine();
            if(line.length() == 0){
                continue;
            }
            char digit = line.charAt(0);
            if(Character.isDigit(digit) && line.contains("chr")){
                if(id == null){
                    id = line;
                }
                if(seq1 == null){
                    seq1 = sn.nextLine();
                }else {
                    seq2 = sn.nextLine();
                }

                if(cle1 == null){
                    cle1 = sn.nextLine();
                }else {
                    cle2 = sn.nextLine();
                    dataList.add(new PairData(id, seq1, cle1, seq2, cle2));
                    id = null;
                    seq1 = null;
                    cle1 = null;

                    seq2 = null;
                    cle2 = null;
                }
            }
        }


    }

    private void loadMetaData(File meta) {
        Scanner sn = null;
        try {
            sn = new Scanner(meta);
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }
        if(sn != null){
            while(sn.hasNext()){
                String line = sn.nextLine();
                headerData.add(line);
                line = sn.nextLine();
                location.add(Integer.parseInt(line));
            }
            sn.close();
        }

    }
}
