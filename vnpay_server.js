const express = require('express');
const crypto = require('crypto');
const app = express();
const PORT = 8080;

// CORS middleware để cho phép Flutter app truy cập
app.use((req, res, next) => {
    res.header('Access-Control-Allow-Origin', '*');
    res.header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE');
    res.header('Access-Control-Allow-Headers', 'Content-Type, Authorization');
    next();
});

// Middleware để parse JSON
app.use(express.json());

// Credentials thực từ web thành công
const vnp_TmnCode = "QAN686SO";
const vnp_HashSecret = "IELZ7UP8UG7S0GXKDS12NM382R9OSP3Q";
const vnp_Url = "https://sandbox.vnpayment.vn/paymentv2/vpcpay.html";
// Sử dụng return URL thực từ web thành công
const returnUrl = "http://fastfood1.somee.com/GioHang/ThanhToanCallback";

app.get('/create_payment', (req, res) => {
    try {
        const date = new Date();
        const createDate = `${date.getFullYear()}${('0' + (date.getMonth() + 1)).slice(-2)}${('0' + date.getDate()).slice(-2)}${('0' + date.getHours()).slice(-2)}${('0' + date.getMinutes()).slice(-2)}${('0' + date.getSeconds()).slice(-2)}`;

        // Thời gian hết hạn: 15 phút từ thời điểm tạo
        const expireDate = new Date(date.getTime() + 15 * 60000);
        const expireDateStr = `${expireDate.getFullYear()}${('0' + (expireDate.getMonth() + 1)).slice(-2)}${('0' + expireDate.getDate()).slice(-2)}${('0' + expireDate.getHours()).slice(-2)}${('0' + expireDate.getMinutes()).slice(-2)}${('0' + expireDate.getSeconds()).slice(-2)}`;

        const amount = Number(req.query.amount || 100000);
        let ipAddr = req.headers['x-forwarded-for'] || req.socket.remoteAddress || '127.0.0.1';
        if (ipAddr.startsWith('::ffff:')) {
            ipAddr = ipAddr.substring(7); // Loại bỏ ::ffff: prefix
        }
        const txnRef = date.getTime().toString();

        // Tạo object params theo thứ tự alphabet
        let params = {
            vnp_Amount: (amount * 100).toString(), // Số tiền * 100 (VNPay yêu cầu)
            vnp_Command: 'pay',
            vnp_CreateDate: createDate,
            vnp_CurrCode: 'VND',
            vnp_ExpireDate: expireDateStr,
            vnp_IpAddr: ipAddr,
            vnp_Locale: 'vn',
            vnp_OrderInfo: `Thanh toan don hang ${txnRef}`,
            vnp_OrderType: 'other',
            vnp_ReturnUrl: returnUrl,
            vnp_TmnCode: vnp_TmnCode,
            vnp_TxnRef: txnRef,
            vnp_Version: '2.1.0'
        };

        // Sắp xếp keys theo thứ tự alphabet
        const sortedKeys = Object.keys(params).sort();

        // Tạo chuỗi ký theo chuẩn web (encode cả key và value)
        const signData = sortedKeys
            .filter(key => key !== 'vnp_SecureHash')
            .map(k => `${encodeURIComponent(k)}=${encodeURIComponent(params[k])}`)
            .join('&');

        console.log('Sign data:', signData); // Debug log
        console.log('Hash secret:', vnp_HashSecret); // Debug log

        // Tạo chữ ký HMAC SHA512
        const hmac = crypto.createHmac("sha512", vnp_HashSecret);
        const signed = hmac.update(Buffer.from(signData, 'utf-8')).digest("hex");

        console.log('Secure hash:', signed); // Debug log
        console.log('Hash length:', signed.length); // Debug log

        // Thêm SecureHash vào params
        params['vnp_SecureHash'] = signed;

        // Tạo query string với encode
        const query = Object.keys(params)
            .map(k => `${k}=${encodeURIComponent(params[k])}`)
            .join('&');

        const paymentUrl = `${vnp_Url}?${query}`;

        console.log('Payment URL:', paymentUrl); // Debug log

        res.json({
            paymentUrl,
            debug: {
                signData,
                secureHash: signed,
                params
            }
        });

    } catch (error) {
        console.error('Error creating payment:', error);
        res.status(500).json({
            error: 'Internal server error',
            message: error.message
        });
    }
});

// Test endpoint để kiểm tra server
app.get('/test', (req, res) => {
    res.json({ message: 'VNPay server is running!' });
});

// Callback endpoint cho VNPay
app.get('/callback', (req, res) => {
    const vnp_SecureHash = req.query['vnp_SecureHash'];
    const vnp_Params = { ...req.query };
    delete vnp_Params['vnp_SecureHash'];
    delete vnp_Params['vnp_SecureHashType'];

    const sortedKeys = Object.keys(vnp_Params).sort();
    const signData = sortedKeys.map(k => `${k}=${encodeURIComponent(vnp_Params[k])}`).join('&');
    const signed = crypto.createHmac('sha512', vnp_HashSecret)
        .update(Buffer.from(signData, 'utf-8'))
        .digest('hex');

    if (signed === vnp_SecureHash) {
        res.json({ message: 'Thanh toán thành công', code: req.query.vnp_ResponseCode });
    } else {
        res.status(400).json({ message: 'Sai chữ ký', yourSign: signed, vnpSign: vnp_SecureHash });
    }
});


app.listen(PORT, () => {
    console.log(`VNPay server running at http://localhost:${PORT}`);
    console.log(`Test endpoint: http://localhost:${PORT}/test`);
    console.log(`Payment endpoint: http://localhost:${PORT}/create_payment?amount=100000`);
});