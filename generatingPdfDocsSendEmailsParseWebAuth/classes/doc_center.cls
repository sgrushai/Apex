public class doc_center {
public string id { get; set; }
public String posType { get; set; }

public doc_center (){
id= ApexPages.currentPage().getParameters().get('id');
posType='Export Bill of Sale';
}

public List<SelectOption> getItems() {
    List<SelectOption> options = new List<SelectOption>();
    options.add(new SelectOption('Mentor','Mentor'));
    options.add(new SelectOption('Consultant','Consultant'));
    options.add(new SelectOption('Permanent','Permanent')); 
    return options;
}
}