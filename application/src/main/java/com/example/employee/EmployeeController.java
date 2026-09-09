package com.example.employee;

import org.springframework.web.bind.annotation.*;
import java.util.*;

@RestController
@RequestMapping("/employees")
public class EmployeeController {

    private final List<Map<String, Object>> employees = new ArrayList<>(
        List.of(
            Map.of("id", 1, "name", "Asha", "role", "DevOps Engineer"),
            Map.of("id", 2, "name", "Rahul", "role", "Developer"),
            Map.of("id", 3, "name", "Priya", "role", "Tester")
        )
    );

    @GetMapping
    public List<Map<String, Object>> getEmployees() {
        return employees;
    }

    @GetMapping("/{id}")
    public Map<String, Object> getEmployee(@PathVariable int id) {
        return employees.stream()
                .filter(employee -> employee.get("id").equals(id))
                .findFirst()
                .orElse(Map.of("error", "Employee not found"));
    }

    @PostMapping
    public Map<String, Object> addEmployee(
            @RequestBody Map<String, Object> employee) {
        employees.add(employee);
        return employee;
    }
}
