/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package tsel;

import java.io.StringReader;
import java.io.StringWriter;
import java.util.ArrayList;
import java.util.Arrays;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.soap.MessageFactory;
import javax.xml.soap.SOAPBody;
import javax.xml.soap.SOAPElement;
import javax.xml.soap.SOAPEnvelope;
import javax.xml.soap.SOAPException;
import javax.xml.soap.SOAPHeader;
import javax.xml.soap.SOAPMessage;
import javax.xml.soap.SOAPPart;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

/**
 *
 * @author Hafidsan
 */
public class CekNum {
    String Anum;
    String RA;
    public String [] nem;
    String responseAnum;
    public String [] quota;
    public String er;
    public ArrayList<String> tlists = new ArrayList<>();
    public ArrayList<String> tlists1 = new ArrayList<>();
    public SOAPMessage reqs(String a) throws Exception{
        MessageFactory mf = MessageFactory.newInstance();
        SOAPMessage sm = mf.createMessage();
        SOAPPart sp = sm.getSOAPPart();
        SOAPEnvelope se = sp.getEnvelope();
        Anum = a;
        SOAPHeader hd = se.getHeader();
        hd.addNamespaceDeclaration("soap", "http://schemas.xmlsoap.org/soap/envelope/");
        SOAPElement lkm = hd.addChildElement("AuthenticationHeader", "orac", "http://www.oracle.com/");
        SOAPElement se1 = lkm.addChildElement("UserName", "orac");
        se1.addTextNode("osb");
        SOAPElement se2 = lkm.addChildElement("PassWord", "orac");
        se2.addTextNode("welcome1");
        SOAPBody sb = se.getBody();
        SOAPElement sel = sb.addChildElement("VP3UPCCRq", "v1","http://www.telkomsel.com/eai/UPCC/VP3UPCCRq/v1.0");
        SOAPElement nm = sel.addChildElement("MSISDN", "v1");
        nm.addTextNode(a);
        SOAPElement nm1 = sel.addChildElement("channel", "v1");
        nm1.addTextNode("TC");
        SOAPElement nm2 = sel.addChildElement("trx_id", "v1");
        nm2.addTextNode("Testing12345");
        sm.writeTo(System.out);
        TransformerFactory transformFactory = TransformerFactory.newInstance();
        Transformer transformer = transformFactory.newTransformer();
            
        Source source = sm.getSOAPPart().getContent();
        StreamResult result = new StreamResult(System.out);
            transformer.transform(source, result);
            
            StringWriter writer = new StringWriter();
            StreamResult results = new StreamResult(writer);
            TransformerFactory tFactory = TransformerFactory.newInstance();
            Transformer transformers = tFactory.newTransformer();
            transformer.transform(source,results);
            String strResult = writer.toString();
            RA = strResult;
            RA = strResult;
            Anum = null;
        return sm;
    }
    
    public void getResponseOSB_A(SOAPMessage response){
        try{
            TransformerFactory transformFactory = TransformerFactory.newInstance();
            Transformer transformer = transformFactory.newTransformer();
            Source source = response.getSOAPPart().getContent();
            StreamResult result = new StreamResult(System.out);
            transformer.transform(source, result);
            
            StringWriter writer = new StringWriter();
            StreamResult results = new StreamResult(writer);
            TransformerFactory tFactory = TransformerFactory.newInstance();
            Transformer transformers = tFactory.newTransformer();
            transformer.transform(source,results);
            String strResult = writer.toString();
            responseAnum = strResult;
            DocumentBuilderFactory docFacs = DocumentBuilderFactory.newInstance();
            DocumentBuilder docBuils = docFacs.newDocumentBuilder();
            InputSource inSoc = new InputSource(new StringReader(strResult));
            Document docs = docBuils.parse(inSoc);
            NodeList userLists0 = docs.getElementsByTagName("v11:VP3UPCCRs");
            Element users0 = (Element) userLists0.item(0);
            er = users0.getElementsByTagName("v11:errorCode").item(0).getTextContent();
            System.out.println("ini er "+er);
            if(er.equals("0000")){
                NodeList userLists = docs.getElementsByTagName("EPCData");
                for (int kl = 0; kl < userLists.getLength(); kl++){
                    Element users = (Element) userLists.item(kl);
                    System.out.println("lklklk "+ docs.getElementsByTagName("LimitUsageName").item(kl).getTextContent());
                    System.out.println("mnmnmn "+ docs.getElementsByTagName("Quota").item(kl).getTextContent());
                    tlists.add(docs.getElementsByTagName("LimitUsageName").item(kl).getTextContent());
                    tlists1.add(docs.getElementsByTagName("Quota").item(kl).getTextContent());
                }
            }
        }catch(Exception e){
            e.printStackTrace();
        }
    }
    
}
