import 'package:flutter/material.dart';
import 'package:tickets/core/models/ticket.dart';

class PaymentCustomerSelectionModal extends StatelessWidget {
  const PaymentCustomerSelectionModal({super.key, required this.onSelected});
  final void Function(PaymentMethod) onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.6,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.person, color: Colors.blueAccent),
              const SizedBox(width: 10),
              Text(
                'Seleccionar método de pago',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(child: Container()),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              itemCount: PaymentMethod.values.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final paymentMethod = PaymentMethod.values[index];
                return ListTile(
                  title: Text(
                    paymentMethod.name,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.blueAccent,
                    ),
                  ),

                  onTap: () {
                    onSelected(paymentMethod);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
