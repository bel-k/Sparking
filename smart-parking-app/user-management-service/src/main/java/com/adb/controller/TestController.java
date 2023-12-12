package com.adb.controller;//package com.adb.controller;
//
//import com.adb.model.Account;
//import com.adb.model.User;
//import com.adb.repository.AccountRepository;
//import com.adb.repository.UserRepository;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.web.bind.annotation.GetMapping;
//import org.springframework.web.bind.annotation.RequestMapping;
//import org.springframework.web.bind.annotation.RestController;
//
//import java.util.List;
//
//@RestController
//@RequestMapping("/api/user-management/test")
//public class TestController {
//    private final UserRepository repo;
//    private final AccountRepository repo1;
//    @Autowired
//    public TestController(UserRepository repo, AccountRepository repo1) {
//        this.repo = repo;
//        this.repo1 = repo1;
//    }
//
////    @PostMapping("/addUser")
////    public String saveBook(@RequestBody User user){
////        repo.save(user);
////
////        return "Added Successfully";
////    }
//    @GetMapping("/findAll")
//    public List<User> getUsers() {
//
//        return repo.findAll();
//    }
//    @GetMapping("/findAllAcc")
//    public List<Account> getAccounts() {
//
//        return repo1.findAll();
//    }
//    @GetMapping("/anon")
//    public String anonEndPoint() {
//        return "everyone can see this";
//    }
//
//    @GetMapping("/users")
//    //@PreAuthorize("hasRole('USER')")
//    public String usersEndPoint() {
//        return "ONLY users can see this";
//    }
//
//    @GetMapping("/admins")
//    //@PreAuthorize("hasRole('ADMIN')")
//    public String adminsEndPoint() {
//        return "ONLY admins can see this";
//    }
//}