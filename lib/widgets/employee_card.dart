import 'package:flutter/material.dart';
import 'package:sqlpro/models/employee.dart';

class EmployeeCard extends StatelessWidget {
  final Employee employee;
  const EmployeeCard({super.key, required this.employee});

  Widget _buildSingleTextRow({required String key, required String value}) {
    return Text(
      '$key: $value',
      style: const TextStyle(
        color: Colors.black,
        fontSize: 13,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                '${employee.firstName} ${employee.lastName}',
              ),
            ),
            const SizedBox(height: 10),
            _buildSingleTextRow(key: 'emp_no', value: employee.id),
            _buildSingleTextRow(key: 'first_name', value: employee.firstName),
            _buildSingleTextRow(key: 'last_name', value: employee.lastName),
            _buildSingleTextRow(
              key: 'birth_date',
              value: employee.birthdate.length <= 10
                  ? ''
                  : employee.birthdate.substring(0, 10),
            ),
            _buildSingleTextRow(key: 'gender', value: employee.gender),
            _buildSingleTextRow(
              key: 'hire_date',
              value: employee.hireDate.length <= 10
                  ? ''
                  : employee.hireDate.substring(0, 10),
            ),
          ],
        ),
      ),
    );
  }
}
