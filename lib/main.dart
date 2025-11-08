import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Beautiful Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  // The number currently showing on display
  String displayText = '0';
  
  // The number we stored for calculations
  double? storedNumber;
  
  // The operation we want to perform (+, -, ×, ÷)
  String? currentOperation;
  
  // Should we clear display when user types next number?
  bool shouldClearDisplay = false;

  // When user presses a number button
  void pressNumber(String number) {
    setState(() {
      if (shouldClearDisplay || displayText == '0') {
        displayText = number;
        shouldClearDisplay = false;
      } else {
        displayText += number;
      }
    });
  }

  // When user presses an operation button (+, -, ×, ÷)
  void pressOperation(String operation) {
    setState(() {
      // If we already have numbers and operation, calculate first
      if (storedNumber != null && currentOperation != null && !shouldClearDisplay) {
        calculateResult();
      } else {
        storedNumber = double.parse(displayText);
      }
      
      currentOperation = operation;
      shouldClearDisplay = true;
    });
  }

  // Calculate the final result
  void calculateResult() {
    if (storedNumber == null || currentOperation == null) return;
    
    final currentNumber = double.parse(displayText);
    double result;
    
    switch (currentOperation) {
      case '+':
        result = storedNumber! + currentNumber;
        break;
      case '-':
        result = storedNumber! - currentNumber;
        break;
      case '×':
        result = storedNumber! * currentNumber;
        break;
      case '÷':
        result = storedNumber! / currentNumber;
        break;
      default:
        return;
    }
    
    setState(() {
      displayText = result.toString();
      if (displayText.endsWith('.0')) {
        displayText = displayText.substring(0, displayText.length - 2);
      }
      storedNumber = result;
      currentOperation = null;
      shouldClearDisplay = true;
    });
  }

  // Clear everything
  void clearAll() {
    setState(() {
      displayText = '0';
      storedNumber = null;
      currentOperation = null;
      shouldClearDisplay = false;
    });
  }

  // Add decimal point
  void addDecimal() {
    setState(() {
      if (shouldClearDisplay) {
        displayText = '0.';
        shouldClearDisplay = false;
      } else if (!displayText.contains('.')) {
        displayText += '.';
      }
    });
  }

  // Make number positive or negative
  void toggleSign() {
    setState(() {
      if (displayText != '0') {
        if (displayText.startsWith('-')) {
          displayText = displayText.substring(1);
        } else {
          displayText = '-$displayText';
        }
      }
    });
  }

  // Convert to percentage
  void convertToPercentage() {
    setState(() {
      final number = double.parse(displayText) / 100;
      displayText = number.toString();
      shouldClearDisplay = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            // Display area
            Expanded(
              flex: 1,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      storedNumber != null && currentOperation != null 
                          ? '${storedNumber!.toString()} $currentOperation'
                          : '',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      displayText,
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w300,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            
            // Buttons area
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // First row: Clear buttons
                    Expanded(
                      child: Row(
                        children: [
                          _buildButton('C', Colors.grey, onPressed: clearAll),
                          _buildButton('±', Colors.grey, onPressed: toggleSign),
                          _buildButton('%', Colors.grey, onPressed: convertToPercentage),
                          _buildButton('÷', Colors.orange, onPressed: () => pressOperation('÷')),
                        ],
                      ),
                    ),
                    
                    // Second row
                    Expanded(
                      child: Row(
                        children: [
                          _buildButton('7', Colors.grey[800]!, onPressed: () => pressNumber('7')),
                          _buildButton('8', Colors.grey[800]!, onPressed: () => pressNumber('8')),
                          _buildButton('9', Colors.grey[800]!, onPressed: () => pressNumber('9')),
                          _buildButton('×', Colors.orange, onPressed: () => pressOperation('×')),
                        ],
                      ),
                    ),
                    
                    // Third row
                    Expanded(
                      child: Row(
                        children: [
                          _buildButton('4', Colors.grey[800]!, onPressed: () => pressNumber('4')),
                          _buildButton('5', Colors.grey[800]!, onPressed: () => pressNumber('5')),
                          _buildButton('6', Colors.grey[800]!, onPressed: () => pressNumber('6')),
                          _buildButton('-', Colors.orange, onPressed: () => pressOperation('-')),
                        ],
                      ),
                    ),
                    
                    // Fourth row
                    Expanded(
                      child: Row(
                        children: [
                          _buildButton('1', Colors.grey[800]!, onPressed: () => pressNumber('1')),
                          _buildButton('2', Colors.grey[800]!, onPressed: () => pressNumber('2')),
                          _buildButton('3', Colors.grey[800]!, onPressed: () => pressNumber('3')),
                          _buildButton('+', Colors.orange, onPressed: () => pressOperation('+')),
                        ],
                      ),
                    ),
                    
                    // Fifth row
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: _buildButton('0', Colors.grey[800]!, onPressed: () => pressNumber('0')),
                          ),
                          _buildButton('.', Colors.grey[800]!, onPressed: addDecimal),
                          _buildButton('=', Colors.orange, onPressed: calculateResult),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper to create beautiful calculator buttons
  Widget _buildButton(String text, Color color, {required VoidCallback onPressed}) {
    final isZeroButton = text == '0';
    
    return Container(
      margin: const EdgeInsets.all(6),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: isZeroButton 
              ? const EdgeInsets.symmetric(horizontal: 32, vertical: 16)
              : const EdgeInsets.all(16),
          elevation: 0,
          shadowColor: Colors.transparent,
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}