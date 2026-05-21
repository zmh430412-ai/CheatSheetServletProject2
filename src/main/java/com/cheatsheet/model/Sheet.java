package com.cheatsheet.model;


import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor // ဒါက String ၃ ခုလုံးပါတဲ့ Constructor ကို ဆောက်ပေးမှာပါ
@NoArgsConstructor  // ဒါက အလွတ် Constructor ကို ဆောက်ပေးမှာပါ
public class Sheet {
	private int id;
	private String title;
	private String description;
	private String codeContent;
	private int categoryId;
	private String categoryName;
}
